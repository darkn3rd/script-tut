<#
.SYNOPSIS
  Runs Invoke-Psake -quiet across every lesson language directory,
  printing each language's own name/version/platform alongside its
  Total/Pass/Fail/Skip line as soon as that language finishes, then one
  grand total summed across every area at the end.

.DESCRIPTION
  PowerShell counterpart to run_all_tests.rb - same behavior, just
  driving Invoke-Psake instead of rake. Both harnesses go through the
  exact same testbox/Script.rb underneath (psakefile.ps1's own tasks
  call Script.rb's methods the same way testbox.rake's tasks do for
  rake), so the printed header/summary text format is identical either
  way - the parsing logic here mirrors run_all_tests.rb's own regexes
  almost exactly, just in PowerShell.

  One real gap: run_all_tests.rb also cross-references
  verify_commands.rb's own package_info (pure Ruby - pacman/dpkg/
  cygcheck/Chocolatey/Homebrew/SDKMAN lookups) to show a binary's real
  package identity (e.g. "Korn Shell (mksh)", not "Korn Shell (ksh)").
  There's no PowerShell port of that logic here - reimplementing it
  would mean duplicating everything verify_commands.rb already does,
  in a second language, needing the same re-testing all over again.
  Instead this shells out to `ruby` for just that one lookup, and
  gracefully falls back to the resolved binary's own filename if ruby
  or verify_commands.rb isn't available at all - this script still
  works standalone, just without that one enrichment.

  A second, more significant gap: run_all_tests.rb's own RAKE_TIMEOUT
  (a hung language can't block the whole run forever) has no working
  equivalent here. A Start-Job-based attempt was tried and abandoned -
  confirmed directly it made things worse, not better: Invoke-Psake ran
  cleanly and quickly called directly, but hung every time inside
  Start-Job (its fully detached, consoleless process seems to break
  Script.rb's own native process spawning). Every language here is
  called with no timeout at all - if one hangs, this script hangs with
  it, the same exposure a naive port would have.

.PARAMETER Selectors
  AREA | AREA/lang | AREA/{lang1,lang2} | AREA/* - same selector syntax
  as run_all_tests.rb. No arguments runs every area/language.

.EXAMPLE
  .\run_all_tests.ps1
.EXAMPLE
  .\run_all_tests.ps1 gen_scripts/perl gen_scripts/{ruby,python3}
#>
[CmdletBinding()]
param(
  [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
  [string[]]$Selectors
)

$ErrorActionPreference = 'Continue'

$LessonRoot = Join-Path $PSScriptRoot '..\..\lessons' | Resolve-Path -ErrorAction SilentlyContinue
if (-not $LessonRoot) {
  $LessonRoot = Join-Path $PSScriptRoot '..\..\lessons'
}

# PsakeTimeoutSeconds - would mirror run_all_tests.rb's own RAKE_TIMEOUT
#  (a hung language shouldn't block the whole run forever), but there is
#  no working implementation of that here yet - confirmed directly a
#  Start-Job-based attempt actively made things *worse*: Invoke-Psake
#  ran cleanly and quickly called directly (both win_scripts/batch and
#  gen_scripts/ruby, matching plain Invoke-Psake's own output exactly),
#  but hung every time inside Start-Job, which runs in a fully detached
#  process with no console attached - something about that breaks
#  Script.rb's own native process spawning (env_shell_out especially).
#  A timeout mechanism that introduces new hangs is worse than having
#  none at all, so Invoke-PsakeRun below calls Invoke-Psake directly
#  with no wrapping - same "if it hangs, it hangs" exposure a naive
#  port would have. Start-ThreadJob (in-process, not a separate
#  detached process) might avoid this, but needs the ThreadJob module
#  and hasn't been tried.
$PsakeTimeoutSeconds = $null

# LanguageDirs - every lesson language directory, grouped by area - the
#  same 22 directories run_all_tests.rb's own LANGUAGE_DIRS describes.
#  [ordered] so area/language iteration order matches every time, same
#  as Ruby's own Hash insertion-order guarantee.
$LanguageDirs = [ordered]@{
  'win_scripts'   = @('batch', 'powershell', 'wsh.jscript', 'wsh.vbscript')
  'shell_scripts' = @('bash', 'csh', 'ksh', 'posix', 'zsh')
  'gen_scripts'   = @('awk', 'groovy', 'perl', 'php', 'python2', 'python3', 'ruby', 'tcl')
  'compiled_lang' = @('cpp', 'cs', 'go', 'java', 'rust')
}

# NativeWindowsShell - true only when actually running on Windows
#  *and* MSYSTEM isn't set - see run_all_tests.rb's own
#  NATIVE_WINDOWS_SHELL comment for the concrete failure mode this
#  guards against (cmd.exe/PowerShell's own `where bash` can resolve to
#  Windows' WSL launcher stub instead of a real bash, which silently
#  corrupts interactive input and eventually hangs).
#  The OS check matters, not just MSYSTEM - confirmed directly checking
#  MSYSTEM alone is wrong: pwsh (PowerShell 7+) runs natively on
#  macOS/Linux too, where MSYSTEM is equally unset (it's an MSYS2-only,
#  Windows-only convention) despite the host being a completely genuine
#  POSIX environment - the original MSYSTEM-only check wrongly skipped
#  shell_scripts/* there as well, exactly the case this whole guard
#  exists to *not* block. $IsWindows only exists in PowerShell 6+
#  (Core/pwsh) - it's absent in Windows PowerShell 5.1, which only ever
#  runs on Windows anyway, so its absence defaults to true safely.
$RunningOnWindows = if (Get-Variable -Name IsWindows -ErrorAction SilentlyContinue) { $IsWindows } else { $true }
$NativeWindowsShell = $RunningOnWindows -and [string]::IsNullOrEmpty($env:MSYSTEM)

# AllowNativeShell - the one exception to NativeWindowsShell's default
#  skip below, stripped from Selectors before Expand-Selection ever
#  sees it so it never gets mistaken for an AREA token - same flag
#  spelling as run_all_tests.rb's own, so it works identically no
#  matter which wrapper is invoked.
$AllowNativeShell = $false
if ($Selectors -contains '--allow-native-shell') {
  $AllowNativeShell = $true
  $Selectors = @($Selectors | Where-Object { $_ -ne '--allow-native-shell' })
}

# NotInstalledPattern - Script.rb's own PATH check (its "Cannot find
#  ... on PATH" fatal check, run before any lesson executes) - matched
#  separately so a genuinely missing interpreter reads as a clean,
#  expected skip rather than a raw "could not parse output" dump.
$NotInstalledPattern = 'ERROR: Cannot find "(\S+)" on PATH'

# Test-ErrorOutput(text) - true if this looks like a shell's own
#  "I don't understand that flag" complaint rather than a real version -
#  same heuristic verify_commands.rb's own error_output? uses, ported
#  here directly rather than shelling out to Ruby for something this
#  cheap and self-contained.
function Test-ErrorOutput {
  param([string]$Text)

  if ([string]::IsNullOrWhiteSpace($Text)) { return $true }
  $firstLine = ($Text -split "`n")[0]
  return [bool]($firstLine -match '(?i)illegal option|unknown option|unrecognized option|invalid option|not recognized|not found|no such file')
}

$WeakVersionPattern = '^shell$'
$BareNumberPattern = '^\d{1,3}$'

# ConvertTo-TrimmedVersion(version) - just the leading "name + version
#  number" portion of a raw version banner - same prefix-stripping and
#  digit-run-match logic as run_all_tests.rb's own trim_version,
#  confirmed directly against the exact same real-world banners (gawk's
#  own verbose comma-separated answer, PHP's parenthetical-heavy one,
#  "Shell (sh) = ..."/"version    sh (AT&T Research) ..."/"go version
#  go1.26.4"/"Groovy Version: 5.0.7" boilerplate prefixes). A length cap
#  at the end is a safety net, not a primary strategy - it guarantees a
#  version banner shape none of the targeted fixes anticipated can
#  misalign this table's columns but never mangle it entirely.
function ConvertTo-TrimmedVersion {
  param([string]$Version)

  if ($null -eq $Version) { return $null }
  if (Test-ErrorOutput $Version) { return 'unknown' }

  $cleaned = $Version `
    -replace '^Shell\s*\([^)]*\)\s*=\s*', '' `
    -replace '^Windows Script Host Version\s+', '' `
    -replace '^version\s+sh\s*\([^)]*\)\s*', '' `
    -replace '^go version\s+', '' `
    -replace '^Groovy Version:\s*', ''
  $cleaned = $cleaned.Trim()

  if ($cleaned -match '^.*?\d+(\.\d+)*') {
    $result = $Matches[0]
  } else {
    $result = ($cleaned -split '[,(\n]')[0]
  }
  $result = $result.Trim()

  if ($result.Length -gt 28) {
    return "$($result.Substring(0, 25))..."
  }
  return $result
}

# Invoke-PsakeRun(dir) - the raw, ANSI-stripped combined output of an
#  Invoke-Psake -quiet run in dir. Called directly, no timeout wrapper -
#  see PsakeTimeoutSeconds's own comment for why: a Start-Job attempt
#  was tried and abandoned after confirming directly it introduces a
#  *new* hang (something about Start-Job's fully detached, consoleless
#  process breaks Script.rb's own native process spawning) that doesn't
#  happen when Invoke-Psake is just called plainly, the way this does.
#  Deliberately does not redirect/close stdin the way a naive port
#  might, either - see run_all_tests.rb's own identical reasoning: some
#  lessons (win_scripts/powershell's n20.setvars.ps1) deliberately pause
#  on real console input, which testbox/Script.rb's own harness already
#  manages correctly per-test.
function Invoke-PsakeRun {
  param([string]$Dir)

  if (-not (Get-Command Invoke-Psake -ErrorAction SilentlyContinue)) {
    return 'Invoke-Psake not found. Is the psake module installed (Install-Module psake)?'
  }

  Push-Location $Dir
  try {
    $output = Invoke-Psake -quiet *>&1 | Out-String
  } catch {
    $output = "ERROR: $_"
  } finally {
    Pop-Location
  }

  return ($output -replace "`e\[\d+m", '')
}

# ConvertFrom-PsakeOutput(output) - pulls the header (Language Target/
#  Version/Environment) and the final Summary line's four counts out of
#  an Invoke-Psake run's own output - see testbox/testbox.rake's header
#  task and Script.print_summary for the exact text this matches
#  against (shared with the rake harness, since both drive the same
#  Script.rb methods). (?m) is required here, unlike Ruby: .NET regex
#  (what PowerShell's -match uses) only treats ^/$ as line anchors in
#  multiline mode, whereas Ruby's ^/$ are *always* line anchors by
#  default - without it, ^Language Target:... would only ever match at
#  the very start of the whole multi-line $Output string, never finding
#  it partway through.
#
#  Greedy up to the *last* "(...)" on the Language Target line, not the
#  first - Script.rb sometimes prints a second parenthetical as part of
#  the language name itself (e.g. "JScript (WSH) (C:\...\cscript.exe)"),
#  and a non-greedy match would grab "(WSH)" as if it were the real
#  path.
function ConvertFrom-PsakeOutput {
  param([string]$Output)

  $result = [ordered]@{
    Language = $null
    Path     = $null
    Version  = $null
    Platform = $null
    Total    = $null
    Pass     = $null
    Fail     = $null
    Skip     = $null
  }

  if ($Output -match '(?m)^Language Target:\s+(.+)\s+\(([^)]+)\)\s*$') {
    $result.Language = $Matches[1]
    $result.Path = $Matches[2]
  }
  if ($Output -match '(?m)^Language Version:\s+(.+)$') { $result.Version = $Matches[1] }
  if ($Output -match '(?m)^Environment:\s+(.+)$') { $result.Platform = $Matches[1] }
  if ($Output -match 'Total=(\d+)') { $result.Total = [int]$Matches[1] }
  if ($Output -match 'Pass=(\d+)') { $result.Pass = [int]$Matches[1] }
  if ($Output -match 'Fail=(\d+)') { $result.Fail = [int]$Matches[1] }
  if ($Output -match 'Skip=(\d+)') { $result.Skip = [int]$Matches[1] }

  return $result
}

# Resolve-PackageInfo(path, binaryName) - shells out to a one-off `ruby`
#  call reusing verify_commands.rb's own package_info directly, rather
#  than reimplementing pacman/dpkg/cygcheck/Chocolatey/Homebrew/SDKMAN
#  lookups a second time in PowerShell - see this file's own top-level
#  comment for why. Returns $null (silently) if ruby isn't on PATH, or
#  verify_commands.rb can't be found/loaded, or the binary just isn't
#  package-tracked - all three cases fall back to display_language/
#  resolve_version's own resolved-binary-filename fallback identically.
function Resolve-PackageInfo {
  param([string]$Path, [string]$BinaryName)

  if (-not $Path) { return $null }
  $ruby = Get-Command ruby -ErrorAction SilentlyContinue
  if (-not $ruby) { return $null }

  $verifyCommandsPath = Join-Path $PSScriptRoot 'verify_commands.rb'
  if (-not (Test-Path $verifyCommandsPath)) { return $null }

  $escapedPath = $Path -replace '\\', '\\\\' -replace "'", "\\'"
  $escapedName = $BinaryName -replace "'", "\\'"
  $rubyScript = @"
require 'json'
require_relative '$($verifyCommandsPath -replace '\\', '/')'
info = package_info('$escapedPath', ['$escapedName'])
puts(info ? info.to_json : 'null')
"@

  try {
    $json = & $ruby.Source -e $rubyScript 2>$null
  } catch {
    return $null
  }
  if (-not $json -or $json.Trim() -eq 'null') { return $null }

  try {
    return $json | ConvertFrom-Json
  } catch {
    return $null
  }
}

# Get-DisplayLanguage(result, pkg) - the generic category Script.rb
#  reports (e.g. "POSIX Shell") plus, when it adds real information,
#  the binary's real package identity when known (e.g. "Korn Shell
#  (mksh)"), falling back to the resolved binary's own filename when no
#  package identity is available at all. Suppressed when that name is
#  already part of the label, using a word-boundary match rather than a
#  plain substring check - "sh" is a substring of the word "Shell"
#  itself, which would wrongly suppress "POSIX Shell (sh)" purely
#  because "sh" hides inside "Shell" - \bsh\b doesn't match there, but
#  still correctly matches "bash" inside "Bourne Again Shell (bash)".
function Get-DisplayLanguage {
  param($Result, $Pkg)

  if (-not $Result.Path) { return $Result.Language }

  $binaryName = [System.IO.Path]::GetFileNameWithoutExtension($Result.Path)
  $name = if ($Pkg -and $Pkg.name) { $Pkg.name } else { $binaryName }

  if (-not $Result.Language) { return $Result.Language }
  if ($Result.Language -match "(?i)\b$([regex]::Escape($name))\b") { return $Result.Language }

  return "$($Result.Language) ($name)"
}

# Resolve-DisplayVersion(result, pkg) - ConvertTo-TrimmedVersion's own
#  answer, falling back to pkg's real package metadata whenever
#  Script.rb's own probe came back weak or erroring - same "only the
#  package really knows" fallback run_all_tests.rb's own resolve_version
#  already leans on.
function Resolve-DisplayVersion {
  param($Result, $Pkg)

  $v = ConvertTo-TrimmedVersion $Result.Version
  if ($v -and $v -ne 'unknown' -and $v -notmatch $WeakVersionPattern -and $v -notmatch $BareNumberPattern) {
    return $v
  }

  if ($Pkg -and $Pkg.version) { return $Pkg.version }
  if ($v) { return $v }
  return 'unknown'
}

# Expand-Selection(argv) - {area => [lang, ...]} to actually run, from
#  positional args like "gen_scripts", "gen_scripts/perl",
#  "gen_scripts/{perl,ruby,python3}", or "gen_scripts/*" - same syntax
#  and parsing as run_all_tests.rb's own expand_selection, for the same
#  reason: PowerShell doesn't do POSIX-style brace/glob expansion any
#  more than cmd.exe does, so this has to be handled here rather than
#  relied on from the invoking shell. No arguments at all means every
#  area/language.
function Expand-Selection {
  param([string[]]$Argv)

  if (-not $Argv -or $Argv.Count -eq 0) {
    return $LanguageDirs
  }

  $selected = [ordered]@{}
  foreach ($token in $Argv) {
    $parts = $token -split '/', 2
    $area = $parts[0]
    $langsPart = if ($parts.Count -gt 1) { $parts[1] } else { '' }

    if (-not $LanguageDirs.Contains($area)) {
      Write-Warning "Unknown area '$area' - skipping (expected one of: $($LanguageDirs.Keys -join ' '))"
      continue
    }
    if (-not $selected.Contains($area)) { $selected[$area] = @() }

    if ([string]::IsNullOrEmpty($langsPart) -or $langsPart -eq '*') {
      $selected[$area] = $LanguageDirs[$area]
      continue
    }

    if ($langsPart.StartsWith('{') -and $langsPart.EndsWith('}')) {
      $names = $langsPart.Substring(1, $langsPart.Length - 2) -split ',' | ForEach-Object { $_.Trim() }
    } else {
      $names = @($langsPart)
    }

    foreach ($name in $names) {
      if ($LanguageDirs[$area] -notcontains $name) {
        Write-Warning "Unknown language '$name' under '$area' - skipping"
        continue
      }
      if ($selected[$area] -notcontains $name) {
        $selected[$area] += $name
      }
    }
  }
  return $selected
}

function Invoke-AllTests {
  param([string[]]$Argv)

  $selection = Expand-Selection $Argv
  $anyLanguages = $false
  foreach ($langs in $selection.Values) { if ($langs.Count -gt 0) { $anyLanguages = $true } }
  if (-not $anyLanguages) {
    Write-Warning 'Nothing to run.'
    return
  }

  $totals = @{ Total = 0; Pass = 0; Fail = 0; Skip = 0 }
  $notInstalled = @()
  $skippedNonPosix = @()

  foreach ($area in $selection.Keys) {
    foreach ($lang in $selection[$area]) {
      if ($area -eq 'shell_scripts' -and $NativeWindowsShell -and -not $AllowNativeShell) {
        Write-Host ('{0,-36} SKIPPED (needs a real POSIX host, not cmd.exe/PowerShell - pass --allow-native-shell to override)' -f $lang)
        $skippedNonPosix += $lang
        continue
      }

      $dir = Join-Path (Join-Path $LessonRoot $area) $lang
      if (-not (Test-Path $dir)) {
        Write-Host "${lang}: directory not found ($dir)"
        continue
      }

      $output = Invoke-PsakeRun $dir

      if ($output -match $NotInstalledPattern) {
        Write-Host ('{0,-36} SKIPPED ({1} not found on PATH)' -f $lang, $Matches[1])
        $notInstalled += $lang
        continue
      }

      $result = ConvertFrom-PsakeOutput $output

      if ($null -eq $result.Total) {
        Write-Host "${lang}: could not parse Invoke-Psake output"
        $output -split "`n" | ForEach-Object { Write-Host "  $_" }
        continue
      }

      $binaryName = if ($result.Path) { [System.IO.Path]::GetFileNameWithoutExtension($result.Path) } else { $null }
      $pkg = Resolve-PackageInfo -Path $result.Path -BinaryName $binaryName

      $displayLanguage = Get-DisplayLanguage $result $pkg
      if (-not $displayLanguage) { $displayLanguage = $lang }
      $displayVersion = Resolve-DisplayVersion $result $pkg
      # ?? is PowerShell 7.0+ only - Windows PowerShell 5.1 (the default
      #  powershell.exe) doesn't understand it, confirmed directly this
      #  broke a real 5.1 session even though it parsed fine under this
      #  environment's own pwsh-backed syntax check.
      $platformDisplay = if ($result.Platform) { $result.Platform } else { '-' }

      Write-Host ('{0,-36} {1,-26} {2,-34} Total={3,-4} Pass={4,-4} Fail={5,-4} Skip={6}' -f `
        $displayLanguage, $displayVersion, $platformDisplay, `
        $result.Total, $result.Pass, $result.Fail, $result.Skip)

      $totals.Total += $result.Total
      $totals.Pass += $result.Pass
      $totals.Fail += $result.Fail
      $totals.Skip += $result.Skip
    }
  }

  Write-Host '==============================================================='
  Write-Host ('Final Summary: Total={0}  Pass={1}  Fail={2}  Skip={3}' -f `
    $totals.Total, $totals.Pass, $totals.Fail, $totals.Skip)
  if ($notInstalled.Count -gt 0) {
    Write-Host "Not installed (skipped): $($notInstalled -join ', ')"
  }
  if ($skippedNonPosix.Count -gt 0) {
    Write-Host "Skipped (non-POSIX host): $($skippedNonPosix -join ', ')"
  }
}

if ($Selectors -and ($Selectors[0] -eq '-h' -or $Selectors[0] -eq '--help')) {
  Write-Host 'Usage: run_all_tests.ps1 [AREA | AREA/lang | AREA/{lang1,lang2} | AREA/*] ... [--allow-native-shell]'
  Write-Host "Areas: $($LanguageDirs.Keys -join ' ')"
  Write-Host 'No arguments runs every area/language.'
  Write-Host 'shell_scripts/* is skipped by default under native Windows PowerShell - it needs'
  Write-Host 'a real POSIX host. Pass --allow-native-shell to run it anyway.'
} else {
  Invoke-AllTests $Selectors
}
