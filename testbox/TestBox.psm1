# =============================================
# TestBox.psm1 - PowerShell-native reimplementation of Script.rb's test
# harness, scoped to the four Windows-native lesson suites under
# win_scripts/ (batch/:cmd, powershell/:ps1, wsh.jscript/:js,
# wsh.vbscript/:vbs). Meant to be driven by psake (see testbox.psake.ps1)
# as a PowerShell-idiomatic sibling to the Ruby/Rake-based testbox.rake,
# for readers specifically interested in psake.
#
# Of the four, only :ps1 can ever run outside Windows - :cmd needs real
# cmd.exe and :js/:vbs need cscript, neither of which exists on macOS/
# Linux regardless of which shell drives them. So unlike Script.rb (which
# has a full PosixShellScript/CommandShellScript/Msys2ShellScript class
# hierarchy), this only branches on platform where :ps1 actually needs
# it: which interpreter binary to invoke (Get-TestBoxCommand), the null
# device (NullDevice), and how a test's stdin gets fed to the child
# process (Invoke-ShellOut) - cmd.exe's piping trick doesn't exist on
# POSIX, so that path writes directly to the child's redirected stdin
# instead. The two Windows-specific quirks Script.rb discovered for the
# :cmd language still apply there and are ported as-is:
#   - NoDefaultCurrentDirectoryInExePath: cmd.exe's implicit current-
#     directory search for a bare executable name can be disabled by a
#     security hardening setting, so :cmd needs an explicit ".\" prefix
#     (see Get-PathPrefix).
#   - SET /p inside a GOTO loop can't correctly consume a pre-built
#     Windows pipe across repeated reads - it just re-reads the first
#     line forever. Feeding input lines one at a time over a live stdin
#     pipe, in response to actual output, works around it (see
#     Invoke-InteractiveShellOut).
# =============================================

# Only :cmd needs either of these - see the module header above.
$script:NeedsPathPrefixLanguages    = @('cmd')
$script:InteractiveRequiredLanguages = @('cmd')

# $IsWindows doesn't exist on Windows PowerShell 5.1 (Desktop edition) -
#  it's $null there, which is falsy, so testing it alone would
#  misdetect a real Windows machine as non-Windows under Desktop. The
#  Desktop edition only ever ships on Windows, so checking PSEdition
#  first covers that case; $IsWindows (Core-only) covers pwsh on both
#  Windows and POSIX.
$script:IsWindowsHost = ($PSVersionTable.PSEdition -eq 'Desktop') -or $IsWindows
$script:NullDevice = if ($script:IsWindowsHost) { 'NUL' } else { '/dev/null' }

$script:Command = @{
    cmd    = 'cmd'
    ps1    = 'powershell'
    js     = 'cscript'
    vbs    = 'cscript'
    awk    = 'gawk'
    groovy = 'groovy'
    pl     = 'perl'
    php    = 'php'
    py     = 'python'
    rb     = 'ruby'
    tcl    = 'tclsh'
}

$script:CommandOptions = @{
    cmd    = '/c'
    ps1    = '-NoLogo -NoProfile -ExecutionPolicy Bypass -File'
    js     = '//Nologo'
    vbs    = '//Nologo'
    awk    = '-f'
    groovy = ''
    pl     = ''
    php    = ''
    py     = ''
    rb     = ''
    tcl    = ''
}

$script:LanguageName = @{
    cmd    = 'Batch'
    ps1    = 'PowerShell'
    js     = 'JScript (WSH)'
    vbs    = 'VBScript (WSH)'
    awk    = 'AWK'
    groovy = 'Groovy'
    pl     = 'Perl'
    php    = 'PHP'
    py     = 'Python'
    rb     = 'Ruby'
    tcl    = 'TCL'
}

# Directories where the extension-derived command isn't the right binary to
#  invoke - ported from Script.rb's @@command_override. python2/ and
#  python3/ both use *.py, but need their own interpreter.
$script:CommandOverride = @{
    python2 = 'python2'
    python3 = 'python3'
}

# Languages with no plain "cmd --version" probe - ported from Script.rb's
#  @@special_version_langs, plus :tcl (tclsh has no --version flag).
$script:SpecialVersionLangs = @('cmd', 'ps1', 'js', 'vbs', 'tcl')

# ported from Script.rb's @@version_probe - {0} is replaced with the
#  resolved command name (see Get-TestBoxCommand), matching Ruby's
#  "%{cmd} --version" substitution for :py (python2/python3 override).
$script:VersionProbe = @{
    awk    = 'gawk --version 2>&1'
    groovy = 'groovy --version 2>&1'
    pl     = 'perl --version 2>&1'
    php    = 'php --version 2>&1'
    py     = '{0} --version 2>&1'
    rb     = 'ruby --version 2>&1'
}

# Get-TestBoxCommand() - resolves to the interpreter binary to invoke,
#  preferring a directory-specific override (see $script:CommandOverride)
#  over the extension-derived default - ported from Script.rb's `command`.
function Get-TestBoxCommand {
    param([string]$Language)
    $dirName = Split-Path -Leaf (Get-Location)
    if ($script:CommandOverride.ContainsKey($dirName)) { return $script:CommandOverride[$dirName] }
    $cmd = $script:Command[$Language]
    # POSIX PowerShell (pwsh) ships as "pwsh", not "powershell" - the
    #  latter is only the Windows Desktop edition executable name (see
    #  the identical fix in Script.rb's `command`).
    if ($cmd -eq 'powershell' -and -not $script:IsWindowsHost) { return 'pwsh' }
    return $cmd
}

# ConvertTo-ExtractedVersion(raw, lang) - ported from Script.rb's
#  extract_version - pulls just the version number/line out of a
#  language's raw "--version" output.
function ConvertTo-ExtractedVersion {
    param([string]$Raw, [string]$Language)
    switch ($Language) {
        { $_ -in 'awk', 'php' } { return ($Raw -split "`n")[0].Trim() }
        'pl' {
            if ($Raw -match 'v\d\.\d{1,2}\.\d') { return $Matches[0] }
            return ''
        }
        'rb' { return ($Raw -split '\s+')[1] }
        default { return $Raw.Trim() }
    }
}

$script:Summary = @{ Total = 0; Pass = 0; Fail = 0; Skip = 0 }

# .NET's Process.StandardInput StreamWriter inherits [Console]::InputEncoding.
#  When that's UTF-8 (as it commonly is nowadays - codepage 65001), it's the
#  *with-BOM* Encoding.UTF8 singleton, and the StreamWriter silently emits a
#  3-byte BOM preamble into the child's stdin pipe the first time it's
#  written to. A batch `SET /p` reads that BOM as its own answer (one extra
#  empty round-trip) before ever seeing real input - forcing a no-BOM UTF-8
#  encoding here avoids that (see Invoke-InteractiveShellOut).
[Console]::InputEncoding = New-Object System.Text.UTF8Encoding($false)

function Get-TestBoxLanguage {
    $a00 = Get-ChildItem -Path . -Filter 'a00.*' | Select-Object -First 1
    if (-not $a00) { throw "No a00.* file found in $(Get-Location) - wrong directory?" }
    return ($a00.Name -split '\.')[-1]
}

function Get-TestBoxDataset {
    if (-not $script:Dataset) {
        $json = Get-Content -Raw '..\..\testbox\expected.json'
        $script:Dataset = ConvertFrom-Json $json
    }
    return $script:Dataset
}

function Get-TestBoxTitles {
    if (-not $script:Titles) {
        $path = '..\..\testbox\titles.json'
        if (Test-Path $path) {
            $script:Titles = ConvertFrom-Json (Get-Content -Raw $path)
        } else {
            $script:Titles = [PSCustomObject]@{}
        }
    }
    return $script:Titles
}

# Get-TestBoxTitle(reference) - human-readable lesson name for a category
#  (e.g. "f0" -> "Collection Loop"), or "" if not found.
function Get-TestBoxTitle {
    param([string]$Reference)
    $titles = Get-TestBoxTitles
    $prop = $titles.PSObject.Properties[$Reference]
    if ($prop) { return $prop.Value } else { return '' }
}

# Get-TestBoxTags(file) - parses "# testbox: key=value" / "REM testbox:
#  key=value" / "' testbox: key=value" style comments from the first few
#  lines of $file into a hashtable. Same convention Script.rb uses -
#  works regardless of comment-marker syntax since it just scans raw text
#  for the "testbox:" pattern, not a specific comment prefix.
function Get-TestBoxTags {
    param([string]$File)
    $tags = @{}
    if (-not (Test-Path $File)) { return $tags }
    $lines = Get-Content -Path $File -TotalCount 5
    foreach ($line in $lines) {
        $matches = [regex]::Matches($line, 'testbox:\s*(\w+)=(?:"([^"]*)"|(\S+))')
        foreach ($m in $matches) {
            $key = $m.Groups[1].Value
            $value = if ($m.Groups[2].Success) { $m.Groups[2].Value } else { $m.Groups[3].Value }
            $tags[$key] = $value
        }
    }
    return $tags
}

function Test-RequiresPosix {
    param([string]$File)
    $tags = Get-TestBoxTags -File $File
    return $tags['requires'] -eq 'posix'
}

function Get-ImplementationTitle {
    param([string]$File)
    $tags = Get-TestBoxTags -File $File
    return $tags['title']
}

function Test-NeedsInteractive {
    param($Test, [string]$Language)
    return ($Test.PSObject.Properties['interactive'] -and $Test.interactive) -and
           ($script:InteractiveRequiredLanguages -contains $Language)
}

function Get-PathPrefix {
    param([string]$Language)
    if ($script:NeedsPathPrefixLanguages -contains $Language) {
        return '.\'
    }
    return ''
}

function Find-TestBoxExecutable {
    param([string]$Command)
    # Get-Command is a built-in cmdlet on both editions/platforms, unlike
    #  where.exe (Windows-only) - also drops the need to branch on
    #  IsWindowsHost here at all.
    $found = Get-Command $Command -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) { return $found.Source }
    return ''
}

# Get-SpecialVersion(lang) - ported directly from CommandShellScript#special_version
function Get-SpecialVersion {
    param([string]$Language)
    switch ($Language) {
        'cmd' {
            $raw = cmd /c ver | Out-String
            if ($raw -match 'Version ([\d.]+)') { return $Matches[1] }
            return ''
        }
        'ps1' {
            return $PSVersionTable.PSVersion.ToString()
        }
        { $_ -in 'js', 'vbs' } {
            $raw = cscript 2>&1 | Out-String
            if ($raw -match 'Windows Script Host Version \S+') { return $Matches[0] }
            return ''
        }
        'tcl' {
            # tclsh itself runs fine on POSIX - only the pipe used to feed
            #  it a one-liner needs to differ (see Invoke-ShellOut for why
            #  a real shell, not pwsh, is used on POSIX).
            if ($script:IsWindowsHost) {
                return (cmd /c 'echo puts [info patchlevel] | tclsh').Trim()
            }
            return (sh -c "echo 'puts [info patchlevel];exit 0' | tclsh").Trim()
        }
        default { return '' }
    }
}

# Get-TestBoxVersion() - human-readable version string for the language
#  under test - ported from Script.rb's `version`. Dispatches to
#  Get-SpecialVersion for languages with no plain "--version" flag (see
#  $script:SpecialVersionLangs); otherwise probes generically and
#  extracts the version substring.
function Get-TestBoxVersion {
    param([string]$Language)
    if ($script:SpecialVersionLangs -contains $Language) {
        return (Get-SpecialVersion -Language $Language).Trim()
    }
    $probe = $script:VersionProbe[$Language]
    if (-not $probe) { return '' }
    $probe = $probe -f (Get-TestBoxCommand -Language $Language)
    # Real shell, not pwsh, on POSIX - same reasoning as Invoke-ShellOut:
    #  these probe strings embed their own "2>&1", which needs fd-level
    #  redirection semantics.
    $raw = if ($script:IsWindowsHost) { cmd /c $probe | Out-String } else { sh -c $probe | Out-String }
    return ConvertTo-ExtractedVersion -Raw $raw -Language $Language
}

# Get-TestBoxEnvironmentLabel() - "Windows (x64)" is always accurate on
#  Windows (psake never runs anywhere else there), but on POSIX the
#  actual OS/arch varies (macOS vs Linux, x86_64 vs arm64) - ask uname
#  rather than hard-coding one.
function Get-TestBoxEnvironmentLabel {
    if ($script:IsWindowsHost) { return 'Windows (x64)' }
    $os = (& uname -s).Trim()
    $arch = (& uname -m).Trim()
    return "$os ($arch)"
}

function Write-TestBoxHeader {
    $lang = Get-TestBoxLanguage
    $cmdName = Get-TestBoxCommand -Language $lang
    $path = Find-TestBoxExecutable -Command $cmdName
    $version = Get-TestBoxVersion -Language $lang
    Write-Host "Environment:      $(Get-TestBoxEnvironmentLabel) via psake"
    Write-Host "Language Target:  $($script:LanguageName[$lang]) ($path)"
    Write-Host "Language Version: $version"
    Write-Host ('=' * 63)
}

# Invoke-ShellOut(commandStr, stdinText) - runs commandStr via cmd.exe on
#  Windows (same as Kernel#` on native Windows Ruby) or via /bin/sh on
#  POSIX (same as Kernel#`'s POSIX backend in Script.rb - see below for
#  why it has to be a real shell, not pwsh itself), and returns raw
#  stdout+stderr as merged text, matching how Script.rb's shell_out/
#  backtick captures.
#  StdinText, when given, is written directly to the child's redirected
#  stdin after it starts - only used on POSIX (see Get-InputRedirect):
#  cmd.exe's nested-`cmd /c "echo ...&echo ..."|` piping trick has no
#  POSIX equivalent, and writing straight to a real redirected stdin
#  pipe sidesteps ever having to embed a test's (arbitrary) input text
#  inside a shell command line at all.
function Invoke-ShellOut {
    param([string]$CommandStr, [string]$StdinText = $null)
    # Not `cmd /c $CommandStr 2>&1 | Out-String`: PowerShell's native command
    #  capture splits output into a line-object array (losing whether a
    #  trailing newline was actually present at all), and Out-String
    #  unconditionally appends its own trailing newline on top of that -
    #  harmless for tests that already expect one, but wrong for tests
    #  (e.g. an unfinished prompt) that specifically expect none. A raw
    #  .NET Process capture preserves the exact byte-for-byte text.
    # Only stdout is captured, matching Ruby's Kernel#` (shell_out) - the
    #  command string always embeds its own "2>&1" or "2> $NullDevice",
    #  so stderr routing is already handled at the shell layer, not here.
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    if ($script:IsWindowsHost) {
        $psi.FileName = 'cmd.exe'
        $psi.Arguments = "/c $CommandStr"
    } else {
        # /bin/sh, not pwsh: PowerShell's own "2>&1"/"2> file" redirection
        #  operators work on *streams* (objects), not raw file descriptors -
        #  a native child's stderr merged via pwsh's 2>&1 gets rewrapped as
        #  a formatted, colorized ErrorRecord (literal ANSI escapes and
        #  all) instead of passed through byte-for-byte, which corrupts any
        #  test comparing exact stderr text. A real shell's 2>&1 is a
        #  plain fd-level dup2, exactly like cmd.exe's on Windows and
        #  Script.rb's own PosixShellScript (which also shells out through
        #  /bin/sh, never pwsh, for this same reason).
        $psi.FileName = '/bin/sh'
        # ArgumentList (an actual argv array), not Arguments (a single
        #  string .NET re-parses/re-quotes using Windows conventions even
        #  on POSIX) - passing $CommandStr as one array element hands it
        #  to sh exactly as written, with no quoting/escaping hazard
        #  regardless of what a lesson's own test data happens to contain.
        $psi.ArgumentList.Add('-c')
        $psi.ArgumentList.Add($CommandStr)
    }
    $psi.RedirectStandardOutput = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    # Without this, the child inherits .NET's Environment.CurrentDirectory,
    #  which PowerShell's Set-Location does not keep in sync with $PWD -
    #  it's process-wide and can go stale across Set-Location calls, so the
    #  child would look for the test scripts in the wrong directory.
    $psi.WorkingDirectory = (Get-Location).Path
    if ($StdinText) { $psi.RedirectStandardInput = $true }

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    [void]$proc.Start()
    if ($StdinText) {
        $proc.StandardInput.Write($StdinText)
        if (-not $StdinText.EndsWith("`n")) { $proc.StandardInput.Write("`n") }
        $proc.StandardInput.Close()
    }
    $stdout = $proc.StandardOutput.ReadToEnd()
    $proc.WaitForExit()

    return ($stdout -replace "`r`n", "`n")
}

# Invoke-InteractiveShellOut(commandStr, inputLines) - see the module
#  header for why :cmd's SET /p-in-a-loop needs this instead of a
#  pre-built pipe. Feeds inputLines one at a time in response to the
#  process actually producing output, mimicking real keystrokes, with a
#  watchdog that force-kills the whole process tree (taskkill /T - a
#  plain Stop-Process only kills the immediate child, not any nested
#  cmd.exe grandchild actually holding the pipe open) if it stalls.
function Invoke-InteractiveShellOut {
    param([string]$CommandStr, [string[]]$InputLines, [int]$TimeoutSeconds = 15)

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'cmd.exe'
    $psi.Arguments = "/c $CommandStr"
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.WorkingDirectory = (Get-Location).Path

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    [void]$proc.Start()

    $remaining = New-Object System.Collections.Generic.Queue[string]
    foreach ($line in $InputLines) { $remaining.Enqueue($line) }

    $output = New-Object System.Text.StringBuilder
    $buffer = New-Object char[] 4096
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)

    # StandardOutput.Peek() is unreliable on a redirected process pipe - it
    #  can return -1 (falsely signaling "no data") even while the process is
    #  still alive and about to write more. ReadAsync()+Task.Wait(timeout) is
    #  what actually works: it blocks (like Ruby's readpartial) until data
    #  arrives or the pipe closes (0 = EOF), but bounded, so a stalled/runaway
    #  process can't hang the whole test run.
    #  Deliberately not a separate watchdog Thread: a PowerShell scriptblock
    #  invoked as a raw .NET ThreadStart delegate runs with no runspace
    #  bound to that thread, and an unhandled error there crashes the whole
    #  host process (not just this function) - which is exactly what an
    #  earlier version of this code did, ~timeout_seconds after any
    #  interactive test ran, even when that test had already passed.
    #  Everything here stays on the calling thread instead.
    while ($true) {
        $remainingMs = [Math]::Max(0, ($deadline - (Get-Date)).TotalMilliseconds)
        $readTask = $proc.StandardOutput.ReadAsync($buffer, 0, $buffer.Length)
        if (-not $readTask.Wait([int]$remainingMs)) {
            if (-not $proc.HasExited) {
                & taskkill /F /T /PID $proc.Id 2>&1 | Out-Null
            }
            break
        }
        $read = $readTask.Result
        if ($read -le 0) { break }
        [void]$output.Append($buffer, 0, $read)
        if ($remaining.Count -gt 0) {
            $proc.StandardInput.WriteLine($remaining.Dequeue())
            $proc.StandardInput.Flush()
        }
    }

    if (-not $proc.HasExited) { $proc.WaitForExit(2000) | Out-Null }

    return ($output.ToString() -replace "`r`n", "`n")
}

# --- tolerance/normalization helpers - ported 1:1 from Script.rb ---

function ConvertTo-TruncatedPrecision {
    param([string]$Text, [int]$Digits)
    return [regex]::Replace($Text, '(\d+\.\d+)', {
        param($m)
        $parts = $m.Value -split '\.', 2
        $frac = $parts[1]
        if ($frac.Length -gt $Digits) { $frac = $frac.Substring(0, $Digits) }
        return "$($parts[0]).$frac"
    })
}

function ConvertTo-NormalizedBool {
    param([string]$Text)
    return [regex]::Replace($Text, '\b(?:true|True|1)\b', 'true')
}

function ConvertTo-NormalizedUnorderedCsv {
    param([string]$Text)
    $lines = $Text -split "`n" | ForEach-Object {
        if ($_ -match '^([^:]*:\s*)(.*)$') {
            $prefix = $Matches[1]
            $items = ($Matches[2] -split ',') | ForEach-Object { $_.Trim() } | Sort-Object
            $prefix + ($items -join ', ')
        } else {
            $_
        }
    }
    return ($lines -join "`n")
}

function ConvertTo-NormalizedUnorderedLines {
    param([string]$Text)
    return (($Text -split "`n") | Sort-Object) -join "`n"
}

function ConvertTo-NormalizedLocaleDecimal {
    param([string]$Text)
    return [regex]::Replace($Text, '(\d),(\d)', '$1.$2')
}

function Test-DatesWithinTolerance {
    param([string]$Expected, [string]$Output, $Days = 1)
    $fmt = '\b([A-Z][a-z]+ \d{1,2}, \d{4})\b'
    $expMatch = [regex]::Match($Expected, $fmt)
    $outMatch = [regex]::Match($Output, $fmt)
    if (-not $expMatch.Success -or -not $outMatch.Success) { return $false }
    try {
        $expDate = [datetime]::ParseExact($expMatch.Groups[1].Value, 'MMMM d, yyyy', $null)
        $outDate = [datetime]::ParseExact($outMatch.Groups[1].Value, 'MMMM d, yyyy', $null)
    } catch {
        return $false
    }
    return [Math]::Abs(($expDate - $outDate).TotalDays) -le $Days
}

function Test-OutputMatches {
    param($Test, [string]$Expected, [string]$Output)
    if ($Test.PSObject.Properties['precision']) {
        $digits = $Test.precision
        return (ConvertTo-TruncatedPrecision $Expected $digits) -eq (ConvertTo-TruncatedPrecision $Output $digits)
    } elseif ($Test.PSObject.Properties['bool']) {
        return (ConvertTo-NormalizedBool $Expected) -eq (ConvertTo-NormalizedBool $Output)
    } elseif ($Test.PSObject.Properties['unordered_csv']) {
        return (ConvertTo-NormalizedUnorderedCsv $Expected) -eq (ConvertTo-NormalizedUnorderedCsv $Output)
    } elseif ($Test.PSObject.Properties['unordered_lines']) {
        return (ConvertTo-NormalizedUnorderedLines $Expected) -eq (ConvertTo-NormalizedUnorderedLines $Output)
    } elseif ($Test.PSObject.Properties['locale_decimal']) {
        return (ConvertTo-NormalizedLocaleDecimal $Expected) -eq (ConvertTo-NormalizedLocaleDecimal $Output)
    } elseif ($Test.PSObject.Properties['date_tolerance']) {
        $days = if ($Test.date_tolerance -eq $true) { 1 } else { $Test.date_tolerance }
        return Test-DatesWithinTolerance -Expected $Expected -Output $Output -Days $days
    } else {
        return $Expected -eq $Output
    }
}

# input_redirect(value) - ported 1:1 from CommandShellScript#input_redirect.
#  Windows-only: on POSIX, Invoke-TestBoxCategory feeds $test.in straight
#  to Invoke-ShellOut's -StdinText instead of building piped command text
#  (see the Invoke-ShellOut comment for why).
function Get-InputRedirect {
    param([string]$Value)
    $lines = ($Value -split "`n") | ForEach-Object { "echo $_" }
    return 'cmd /c "' + ($lines -join '&') + '"|'
}

# Invoke-TestBoxCategory(task) - the core comparison loop, ported from
#  Script.rb's execute(). Returns a result object for Write-TestBoxReport.
function Invoke-TestBoxCategory {
    param([string]$Task)

    $language = Get-TestBoxLanguage
    $list = @(Get-ChildItem -Path . -Filter "${Task}?.*" | Sort-Object Name | ForEach-Object { $_.Name })

    $hadPosixOnly = ($list | Where-Object { Test-RequiresPosix $_ }).Count -gt 0
    $list = @($list | Where-Object { -not (Test-RequiresPosix $_) })

    $result = [ordered]@{
        Category    = $Task
        Skipped     = $false
        SkipReason  = $null
        FinalResult = $true
        Results     = [ordered]@{}
    }

    if ($list.Count -eq 0) {
        $result.Skipped = $true
        if ($hadPosixOnly) { $result.SkipReason = 'requires a POSIX shell' }
        return [PSCustomObject]$result
    }

    $dataset = Get-TestBoxDataset
    $taskDataProp = $dataset.PSObject.Properties[$Task]
    if (-not $taskDataProp) {
        $result.FinalResult = $false
        return [PSCustomObject]$result
    }
    $taskData = $taskDataProp.Value

    foreach ($cmd in $list) {
        $key = ($cmd -split '\.')[0]
        if (-not $result.Results.Contains($key)) { $result.Results[$key] = @() }

        foreach ($test in $taskData) {
            $redirect = ''
            $expected = ''
            $args = ''
            $input = ''
            $inputLines = $null
            $stdinText = $null

            if ($test.PSObject.Properties['err']) {
                $redirect = '2>&1'
                $expected = $test.err
            } else {
                $redirect = "2> $($script:NullDevice)"
                $expected = $test.out
            }

            if ($test.PSObject.Properties['arg']) { $args = $test.arg }

            if ($test.PSObject.Properties['in']) {
                if (Test-NeedsInteractive -Test $test -Language $language) {
                    $inputLines = $test.in -split "`n"
                } elseif ($script:IsWindowsHost) {
                    $input = Get-InputRedirect -Value $test.in
                } else {
                    $stdinText = $test.in
                }
            }

            $expected = $expected -replace '\$cmd\$', $cmd
            $expected = $expected -replace '\$date\$', (Get-Date -Format 'MMMM dd, yyyy')

            $prefix = Get-PathPrefix -Language $language
            $runner = "$(Get-TestBoxCommand -Language $language) $($script:CommandOptions[$language])"
            $command = "$input $runner $prefix$cmd $args $redirect"

            if (Test-NeedsInteractive -Test $test -Language $language) {
                $output = Invoke-InteractiveShellOut -CommandStr $command -InputLines $inputLines
            } else {
                $output = Invoke-ShellOut -CommandStr $command -StdinText $stdinText
            }

            $testResult = Test-OutputMatches -Test $test -Expected $expected -Output $output

            $result.Results[$key] += [PSCustomObject]@{
                Command    = $command
                Output     = $output
                Expected   = $expected
                TestResult = $testResult
                Diff       = $expected -ne $output
                Title      = Get-ImplementationTitle -File $cmd
            }

            $result.FinalResult = $result.FinalResult -and $testResult
        }
    }

    return [PSCustomObject]$result
}

function Write-Colored {
    param([string]$Text, [string]$Color)
    Write-Host $Text -ForegroundColor $Color -NoNewline
}

function Format-PassFail {
    param([bool]$Passed)
    if ($Passed) { return @{ Text = 'PASS'; Color = 'Green' } }
    return @{ Text = 'FAIL'; Color = 'Red' }
}

# Write-TestBoxDiff(testCase) - ported from Script.rb's print_diff: prints
#  nothing on a clean pass. On a pass that only succeeded via tolerance
#  (e.g. "precision"), both lines print yellow so the raw difference is
#  still visible. On a real fail, Expected prints green (what it should've
#  been) and Actual prints red (what it was).
function Write-TestBoxDiff {
    param($TestCase)
    if ($TestCase.TestResult -and -not $TestCase.Diff) { return }

    $expectedText = $TestCase.Expected -replace "`n", '\n'
    $outputText   = $TestCase.Output -replace "`n", '\n'

    if ($TestCase.TestResult) {
        Write-Host "         Expected Output: |" -NoNewline
        Write-Colored $expectedText 'Yellow'
        Write-Host "|"
        Write-Host "         Actual Output:   |" -NoNewline
        Write-Colored $outputText 'Yellow'
        Write-Host "| (within tolerance)"
    } else {
        Write-Host "         Expected Output: |" -NoNewline
        Write-Colored $expectedText 'Green'
        Write-Host "|"
        Write-Host "         Actual Output:   |" -NoNewline
        Write-Colored $outputText 'Red'
        Write-Host "|"
    }
}

# Write-TestBoxReport(results) - ported from Script.rb's report()
function Write-TestBoxReport {
    param($Results)

    $title = Get-TestBoxTitle -Reference $Results.Category
    $label = (Get-Culture).TextInfo.ToTitleCase($Results.Category) + $(if ($title) { " - $title" } else { '' })

    if ($Results.Skipped) {
        $script:Summary.Skip++
        $reason = if ($Results.SkipReason) { " ($($Results.SkipReason))" } else { '' }
        Write-Host "${label}: [" -NoNewline
        Write-Colored 'SKIP' 'Yellow'
        Write-Host "]$reason"
        return
    }

    $script:Summary.Total++
    if ($Results.FinalResult) { $script:Summary.Pass++ } else { $script:Summary.Fail++ }

    $anyDiff = @($Results.Results.Values | ForEach-Object { $_ } | Where-Object { $_.Diff }).Count -gt 0
    $hasTitles = @($Results.Results.Values | ForEach-Object { $_ } | Where-Object { $_.Title }).Count -gt 0

    $pf = Format-PassFail $Results.FinalResult
    Write-Host "${label}: [" -NoNewline
    Write-Colored $pf.Text $pf.Color
    Write-Host "]"

    if (-not $Results.FinalResult -or $anyDiff -or $hasTitles) {
        if ($Results.Results.Count -eq 0) {
            Write-Host "      - There are no implementations for this category."
        } else {
            foreach ($entry in $Results.Results.GetEnumerator()) {
                $implTitle = $entry.Value[0].Title
                $implLabel = (Get-Culture).TextInfo.ToTitleCase($entry.Key) + $(if ($implTitle) { " - $implTitle" } else { '' })

                if ($entry.Value.Count -eq 1) {
                    $tc = $entry.Value[0]
                    $tpf = Format-PassFail $tc.TestResult
                    Write-Host "      - ${implLabel}: [" -NoNewline
                    Write-Colored $tpf.Text $tpf.Color
                    Write-Host "]"
                    Write-TestBoxDiff -TestCase $tc
                } else {
                    Write-Host "      - $implLabel ($($entry.Value.Count) testcases):"
                    $count = 1
                    foreach ($tc in $entry.Value) {
                        $tpf = Format-PassFail $tc.TestResult
                        Write-Host "        - Test ${count}: [" -NoNewline
                        Write-Colored $tpf.Text $tpf.Color
                        Write-Host "]"
                        Write-TestBoxDiff -TestCase $tc
                        $count++
                    }
                }
            }
        }
    }
}

function Invoke-TestBoxTask {
    param([string]$Task)
    Write-TestBoxReport (Invoke-TestBoxCategory -Task $Task)
}

function Show-TestBoxSummary {
    Write-Host ('=' * 63)
    Write-Host "Summary: Total=$($script:Summary.Total)  " -NoNewline
    Write-Colored "Pass=$($script:Summary.Pass)  " 'Green'
    Write-Colored "Fail=$($script:Summary.Fail)  " 'Red'
    Write-Colored "Skip=$($script:Summary.Skip)" 'Yellow'
    Write-Host ""
}

Export-ModuleMember -Function * -Variable *
