# =============================================
# TestBox.psm1 - PowerShell-native reimplementation of Script.rb's test
# harness. Meant to be driven by psake (see testbox.psake.ps1) as a
# PowerShell-idiomatic sibling to the Ruby/Rake-based testbox.rake, for
# readers specifically interested in psake. Every lesson directory with
# a psakefile.ps1 uses this - the four Windows-native suites under
# lessons/win_scripts/ (batch/:cmd, powershell/:ps1, wsh.jscript/:js,
# wsh.vbscript/:vbs), the interpreted languages under lessons/gen_scripts/
# (:awk/:groovy/:pl/:php/:py/:rb/:tcl), and the five compiled languages
# under lessons/compiled_lang/ (:java/:go/:rs/:cpp/:cs - see $script:Compiler and
# Confirm-TestBoxCompiled).
#
# Of the Windows-native four, only :ps1 can ever run outside Windows -
# :cmd needs real cmd.exe and :js/:vbs need cscript, neither of which
# exists on macOS/Linux regardless of which shell drives them. So unlike
# Script.rb (which has a full PosixShellScript/CommandShellScript/
# Msys2ShellScript class hierarchy), this only branches on platform
# where it actually needs to: which interpreter/compiler binary to
# invoke (Get-TestBoxCommand), the null device (NullDevice), and how a
# test's stdin gets fed to the child process (Invoke-ShellOut) - cmd.exe's
# piping trick doesn't exist on POSIX, so that path writes directly to
# the child's redirected stdin instead. The two Windows-specific quirks
# Script.rb discovered for the :cmd language still apply here and are
# ported as-is:
#   - NoDefaultCurrentDirectoryInExePath: cmd.exe's implicit current-
#     directory search for a bare executable name can be disabled by a
#     security hardening setting, so :cmd (and every compiled language,
#     for the same reason - its own build artifact is what's being
#     resolved that way too) needs an explicit ".\" prefix (see
#     Get-PathPrefix).
#   - SET /p inside a GOTO loop can't correctly consume a pre-built
#     Windows pipe across repeated reads - it just re-reads the first
#     line forever. Feeding input lines one at a time over a live stdin
#     pipe, in response to actual output, works around it (see
#     Invoke-InteractiveShellOut).
# =============================================

# compiler binary for each compiled language (see $script:CompiledLanguages
#  and Confirm-TestBoxCompiled). Unlike $script:Command (an interpreter
#  that the test file is handed to as a data argument), these only ever
#  run once per session, via `make`, to produce the actual thing invoked
#  per test - ported from Script.rb's @@compiler.
$script:Compiler = @{
    java = 'javac'
    go   = 'go'
    rs   = 'rustc'
    cpp  = 'g++'
    cs   = 'dotnet'
}

# Languages with no interpreter at all (see $script:Command) - a lesson
#  file here is only ever handed to `make` (see Confirm-TestBoxCompiled),
#  and what actually gets invoked per test is the resulting build
#  artifact (see Get-InvocationName), not the source file itself -
#  ported from Script.rb's @@compiled_languages.
$script:CompiledLanguages = @($script:Compiler.Keys)

# :cmd needs this because of NoDefaultCurrentDirectoryInExePath (see the
#  module header); every compiled language needs it because its own
#  build artifact lives in a bin/ subdirectory, not right next to the
#  invocation - see Get-PathPrefix - ported from Script.rb's
#  @@needs_path_prefix_languages.
$script:NeedsPathPrefixLanguages    = @('cmd') + $script:CompiledLanguages
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
    awk    = 'awk'
    groovy = 'groovy'
    pl     = 'perl'
    php    = 'php'
    py     = 'python'
    rb     = 'ruby'
    tcl    = 'tclsh'
    bash   = 'bash'
    csh    = 'tcsh'
    sh     = 'sh'
    ksh    = 'ksh'
    zsh    = 'zsh'
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
    bash   = ''
    csh    = ''
    sh     = ''
    ksh    = ''
    zsh    = ''
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
    bash   = 'Bourne Again Shell'
    csh    = 'C-Shell'
    sh     = 'POSIX Shell'
    ksh    = 'Korn Shell'
    zsh    = 'Z Shell'
    java   = 'Java'
    go     = 'Go'
    rs     = 'Rust'
    cpp    = 'C++'
    cs     = 'C#'
}

# Directories where the extension-derived command isn't the right binary to
#  invoke - ported from Script.rb's @@command_override. python2/ and
#  python3/ both use *.py, but need their own interpreter.
$script:CommandOverride = @{
    python2 = 'python2'
    python3 = 'python3'
}

# Captured once, at module import time, before the Set-Location below -
#  this identifies the *language* directory (e.g. "python3", used by
#  $script:CommandOverride), never wherever the harness ends up actually
#  running lessons from. Unlike Script.rb's @@dirname (a class variable
#  set once when the class loads), Get-TestBoxCommand below is an
#  ordinary function called repeatedly through the run - deriving this
#  from Get-Location fresh on every call would read back "scripts" after
#  the Set-Location below, not the language name.
$script:LanguageDirName = Split-Path -Leaf (Get-Location)

# lessons/gen_scripts, lessons/win_scripts, lessons/shell_scripts lesson
#  directories keep their
#  actual lesson files - plus dirtest/ and any other fixture a lesson
#  needs - in a scripts/ subdirectory; psakefile.ps1/README stay at the
#  language directory root (see ../README.md's Directory Structure
#  section). Changing into it here, once, for the rest of the session
#  means every Get-ChildItem/Get-Content/invocation below keeps working
#  completely unchanged, exactly as if the lessons had never moved: a
#  script invoked as a bare filename still finds itself at "." (now
#  scripts/), and self-name introspection (PowerShell's
#  $MyInvocation.MyCommand.Name, a batch lesson's %~nx0, ...) still
#  reports that same bare filename, not a "scripts\"-prefixed path - so
#  expected.json's $cmd$ substitution (see Invoke-TestBoxCategory) needs
#  no per-language handling for the move at all.
if (Test-Path -PathType Container 'scripts') {
    Set-Location 'scripts'
}

# lessons/compiled_lang/*/src/ is the other lesson-file convention this harness
#  supports, alongside scripts/ above - but unlike scripts/, it
#  deliberately does NOT Set-Location there: `make`, the promoted bin/
#  binaries it builds, and the dirtest/ fixture some of them read all
#  need the current location to stay at the language directory root
#  (bin\a00.output is invoked as a relative path *from* there, and a
#  compiled binary's own working directory follows whoever spawned it,
#  not wherever its own executable file happens to live - see
#  lessons/compiled_lang/README.md). Only Get-TestBoxLanguage, Invoke-
#  TestBoxCategory's Get-ChildItem, and Get-TestBoxTags's file reads
#  need to know where src/ actually is; "." here (scripts/ already
#  changed into, or a language directory that simply uses neither
#  convention) means "wherever we already are" - ported from Script.rb's
#  @@source_subdir.
$script:SourceSubdir = if (Test-Path -PathType Container 'src') { 'src' } else { '.' }

# Languages with no plain "cmd --version" probe - ported from Script.rb's
#  @@special_version_langs, plus :tcl (tclsh has no --version flag). :sh
#  joins this list because it's resolved dynamically (see
#  Get-TestBoxCommand's dash preference) rather than through a static
#  $script:VersionProbe entry - same reasoning as Script.rb's
#  PosixShellScript#special_version :sh case.
$script:SpecialVersionLangs = @('cmd', 'ps1', 'js', 'vbs', 'tcl', 'sh')

# ported from Script.rb's @@version_probe - {0} is replaced with the
#  resolved command name (see Get-TestBoxCommand), matching Ruby's
#  "%{cmd} --version" substitution for :py (python2/python3 override).
$script:VersionProbe = @{
    awk    = 'awk --version 2>&1'
    groovy = 'groovy --version 2>&1'
    pl     = 'perl --version 2>&1'
    php    = 'php --version 2>&1'
    py     = '{0} --version 2>&1'
    rb     = 'ruby --version 2>&1'
    bash   = 'bash --version 2>&1'
    csh    = 'csh --version 2>&1'
    ksh    = 'ksh --version 2>&1'
    zsh    = 'zsh --version 2>&1'
    java   = 'javac -version 2>&1'
    go     = 'go version 2>&1'
    rs     = 'rustc --version 2>&1'
    cpp    = 'g++ --version 2>&1'
    cs     = 'dotnet --version 2>&1'
}

# commands already confirmed present on PATH this run (see
#  Get-TestBoxCommand) - a HashSet so a missing interpreter/compiler fails
#  loudly exactly once, not on every single test that would otherwise try
#  and fail to invoke it - ported from Script.rb's @@verified_commands.
$script:VerifiedCommands = New-Object System.Collections.Generic.HashSet[string]

# Get-TestBoxCommand() - resolves to the interpreter binary to invoke,
#  preferring a directory-specific override (see $script:CommandOverride)
#  over the extension-derived default - ported from Script.rb's `command`.
function Get-TestBoxCommand {
    param([string]$Language)
    if ($script:CommandOverride.ContainsKey($script:LanguageDirName)) { return $script:CommandOverride[$script:LanguageDirName] }
    # $script:Command has no entry for a compiled language - it falls
    #  through to $script:Compiler, since that's the one thing that
    #  actually needs to be on PATH to run these lessons at all (see
    #  Confirm-TestBoxCompiled). Reusing this function for that, rather
    #  than a separate one, means the same PATH-verification and
    #  header-display logic (see Write-TestBoxHeader) covers both cases
    #  for free.
    $cmd = $script:Command[$Language]
    if (-not $cmd) { $cmd = $script:Compiler[$Language] }
    # POSIX PowerShell (pwsh) ships as "pwsh", not "powershell" - the
    #  latter is only the Windows Desktop edition executable name (see
    #  the identical fix in Script.rb's `command`).
    if ($cmd -eq 'powershell' -and -not $script:IsWindowsHost) { $cmd = 'pwsh' }
    # lessons/shell_scripts/posix's lessons target genuine POSIX shell semantics,
    #  not whatever a distro's /bin/sh happens to be symlinked to - dash
    #  is a strict POSIX implementation, so prefer it explicitly when
    #  it's on PATH, falling back to plain "sh" otherwise - Script.rb now
    #  has this identical preference in its own `command` method.
    if ($cmd -eq 'sh' -and -not $script:IsWindowsHost -and (Find-TestBoxExecutable -Command 'dash')) {
        $cmd = 'dash'
    }
    # Fail once, loudly, and stop - ported from Script.rb's `command`. A
    #  missing interpreter/compiler would otherwise silently run every
    #  single lesson through a shell that immediately errors ("zsh: not
    #  found"), surfacing as a wall of confusing empty-output FAILs
    #  instead of one clear diagnostic naming the actual missing binary.
    if (-not $script:VerifiedCommands.Contains($cmd)) {
        if (-not (Find-TestBoxExecutable -Command $cmd)) {
            throw "Cannot find `"$cmd`" on PATH (needed to run $($script:LanguageDirName)/ lessons). Check the setup instructions for this language."
        }
        [void]$script:VerifiedCommands.Add($cmd)
    }
    return $cmd
}

# ConvertTo-ExtractedVersion(raw, lang) - ported from Script.rb's
#  extract_version - pulls just the version number/line out of a
#  language's raw "--version" output.
function ConvertTo-ExtractedVersion {
    param([string]$Raw, [string]$Language)
    switch ($Language) {
        # cpp: g++ --version's output is multiple lines (version line,
        #  then copyright/license) - just the first line, same as awk/php/
        #  bash/zsh (see Script.rb's identical extract_version case).
        { $_ -in 'awk', 'php', 'cpp', 'bash', 'zsh' } { return ($Raw -split "`n")[0].Trim() }
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
    $a00 = Get-ChildItem -Path $script:SourceSubdir -Filter 'a00.*' | Select-Object -First 1
    if (-not $a00) { throw "No a00.* file found under $script:SourceSubdir in $(Get-Location) - wrong directory?" }
    return ($a00.Name -split '\.')[-1]
}

function Get-TestBoxDataset {
    if (-not $script:Dataset) {
        # $PSScriptRoot-based, not "..\..\testbox\..." - robust regardless
        #  of the Set-Location above, since it resolves relative to this
        #  module's own location (testbox\) rather than counting
        #  directory levels up from wherever the current location
        #  happens to be.
        $json = Get-Content -Raw (Join-Path $PSScriptRoot 'expected.json')
        $script:Dataset = ConvertFrom-Json $json
    }
    return $script:Dataset
}

function Get-TestBoxTitles {
    if (-not $script:Titles) {
        $path = Join-Path $PSScriptRoot 'titles.json'
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
    # $script:SourceSubdir-qualified, same reasoning as Get-TestBoxLanguage -
    #  $File is always a bare filename, and the current location isn't
    #  necessarily where it actually lives on disk (see
    #  $script:SourceSubdir's own comment).
    $qualified = Join-Path $script:SourceSubdir $File
    if (-not (Test-Path $qualified)) { return $tags }
    $lines = Get-Content -Path $qualified -TotalCount 5
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
    if ($script:NeedsPathPrefixLanguages -notcontains $Language) { return '' }
    # A compiled language additionally builds into a bin/ subdirectory
    #  (see lessons/compiled_lang/README.md), so its prefix includes that too -
    #  ported from Script.rb's execute().
    $sep = if ($script:IsWindowsHost) { '\' } else { '/' }
    $subdir = if ($script:CompiledLanguages -contains $Language) { "bin$sep" } else { '' }
    return ".$sep$subdir"
}

# Get-BinaryExtension() - the real on-disk extension of the artifact
#  `make` produces for the current compiled language (see
#  lessons/compiled_lang/*/Makefile) - ported from Script.rb's binary_extension.
function Get-BinaryExtension {
    param([string]$Language)
    if (-not $script:IsWindowsHost) { return '' }
    # ".bat", not ".cmd": :cmd (Batch) already owns ".cmd" as its own
    #  lesson source extension - see Script.rb's binary_extension for why
    #  this matters for language auto-detection.
    if ($Language -eq 'java') { return '.bat' }
    return '.exe'
}

# Get-InvocationName(cmd, language) - what to actually put on the command
#  line for lesson file $cmd. For an interpreted language this is just
#  $cmd itself; for a compiled language it's the build artifact's own
#  name (see Get-BinaryExtension) - ported from Script.rb's
#  invocation_name.
function Get-InvocationName {
    param([string]$Cmd, [string]$Language)
    if ($script:CompiledLanguages -notcontains $Language) { return $Cmd }
    return ($Cmd -replace '\.[^.]+$', '') + (Get-BinaryExtension -Language $Language)
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

# Invoke-StreamShellOut(commandStr) - like Invoke-ShellOut, but prints
#  commandStr's combined output line-by-line as it's produced instead of
#  capturing it silently until the process exits. Used only for the
#  one-time `make` build in Confirm-TestBoxCompiled - a compiled
#  language's full build can take a noticeable moment, and without this
#  the harness sits in total silence for that whole stretch before the
#  first test result appears. Returns whether the command exited
#  successfully - ported from Script.rb's stream_shell_out.
function Invoke-StreamShellOut {
    param([string]$CommandStr)
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    if ($script:IsWindowsHost) {
        $psi.FileName = 'cmd.exe'
        $psi.Arguments = "/c $CommandStr"
    } else {
        $psi.FileName = '/bin/sh'
        $psi.ArgumentList.Add('-c')
        $psi.ArgumentList.Add($CommandStr)
    }
    $psi.RedirectStandardOutput = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.WorkingDirectory = (Get-Location).Path

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    [void]$proc.Start()
    while ($null -ne ($line = $proc.StandardOutput.ReadLine())) {
        Write-Host $line
    }
    $proc.WaitForExit()
    return $proc.ExitCode -eq 0
}

# Confirm-TestBoxCompiled(language) - for a compiled language (see
#  $script:CompiledLanguages), runs `make` in the lesson directory once
#  per session, before any test tries to invoke a build artifact that
#  doesn't exist yet. `make` itself, and the compiler it drives (see
#  Get-TestBoxCommand), are each verified present and failed loudly and
#  once if missing - the same "fail once, clearly" reasoning as a
#  missing interpreter - because a broken build would otherwise surface
#  as the exact same confusing per-test error on every single test in
#  the directory - ported from Script.rb's ensure_compiled!.
$script:CompiledOk = $false
function Confirm-TestBoxCompiled {
    param([string]$Language)
    if ($script:CompiledLanguages -notcontains $Language) { return }
    if ($script:CompiledOk) { return }

    $cmdName = Get-TestBoxCommand -Language $Language
    if (-not (Find-TestBoxExecutable -Command $cmdName)) {
        throw "Cannot find `"$cmdName`" on PATH (needed to build $($script:LanguageDirName)/ lessons). Check the setup instructions for this language."
    }

    if (-not (Find-TestBoxExecutable -Command 'make')) {
        throw "Cannot find `"make`" on PATH (needed to build $($script:LanguageDirName)/ lessons). Check the setup instructions for this language."
    }

    # A second, separate status header from the one Write-TestBoxHeader
    #  prints - $script:CompiledOk means this only runs once per psake
    #  invocation (the first test category to run triggers it; every
    #  later category in the same run skips straight past). `make`
    #  itself is still incremental across separate invocations, so a
    #  second run with nothing changed just streams a fast "Nothing to
    #  be done" instead of silently doing nothing.
    Write-Host "Compiling $($script:LanguageName[$Language]) lessons (one-time build)..."
    Write-Host ('=' * 63)
    $success = Invoke-StreamShellOut -CommandStr 'make 2>&1'
    Write-Host ('=' * 63)

    if (-not $success) {
        throw "``make`` failed while building $($script:LanguageDirName)/ lessons (see output above)."
    }

    $script:CompiledOk = $true
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
        'sh' {
            # dash (and most minimal POSIX shells) has no --version flag
            #  at all - "unknown" here is the expected, common case, not
            #  a failure, matching Script.rb's PosixShellScript#special_version
            #  :sh case. Queries whatever Get-TestBoxCommand actually
            #  resolved to (dash or sh), not a hardcoded "sh", so the
            #  label reflects the real interpreter running the lessons.
            $cmd = Get-TestBoxCommand -Language 'sh'
            $raw = (& $cmd --version 2>$null | Select-Object -First 1)
            if ($raw) { return "Shell (sh) = $raw" }
            return 'Shell (sh) = unknown'
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
        # A missing/misbehaving interpreter (e.g. csh not on PATH) can
        #  make the child exit before ever reading stdin - writing to its
        #  already-closed pipe then throws IOException ("Broken pipe").
        #  That should surface as this one test's own FAIL (via empty
        #  stdout below), not an unhandled crash of the whole psake run -
        #  same reasoning as Script.rb's env_shell_out EPIPE rescue.
        try {
            $proc.StandardInput.Write($StdinText)
            if (-not $StdinText.EndsWith("`n")) { $proc.StandardInput.Write("`n") }
            $proc.StandardInput.Close()
        } catch [System.IO.IOException] {
        }
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

# $script:DumpEnvFile - the file a lesson dumps its own environment to
#  (see Invoke-EnvShellOut) - a fixed, well-known name in the current
#  directory, same convention every language's n20.setvars.* lesson
#  follows - ported from Script.rb's DUMP_ENV_FILE.
$script:DumpEnvFile = 'dump_env.out'

# Invoke-EnvShellOut(commandStr, expectedEnv) - like Invoke-ShellOut, but
#  for a lesson that dumps its own environment to $script:DumpEnvFile and
#  then blocks on stdin (see n20.setvars.* - "MY_ORDERS set, Hit Return
#  to continue") instead of writing anything comparable to stdout/stderr.
#
#  Inspecting a lesson's *live* process environment from the outside
#  isn't reliably possible on either side of this harness - see
#  Script.rb's env_shell_out for what was tried (/proc, ps, Get-Process)
#  and ruled out. Dumping to a file the lesson itself controls sidesteps
#  all of that: reading it is plain file I/O, no OS-specific process
#  introspection needed anywhere.
#
#  Starts commandStr, waits for its prompt line (by which point
#  $script:DumpEnvFile is guaranteed to already exist) using the same
#  ReadAsync+Task.Wait(timeout) pattern as Invoke-InteractiveShellOut - a
#  single ReadLineAsync stands in for that function's read loop here,
#  since only one line (the prompt, discarded - just used for
#  synchronization) is ever needed - then reads the dump file directly,
#  and writes a newline to unblock the lesson, which deletes
#  $script:DumpEnvFile itself as part of its own exit. Returns a
#  PSCustomObject of {key = actual_value} for every key ExpectedEnv asked
#  about - Test-EnvMatches compares this against ExpectedEnv itself.
function Invoke-EnvShellOut {
    param([string]$CommandStr, $ExpectedEnv, [int]$TimeoutSeconds = 15)

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    if ($script:IsWindowsHost) {
        $psi.FileName = 'cmd.exe'
        $psi.Arguments = "/c $CommandStr"
    } else {
        $psi.FileName = '/bin/sh'
        $psi.ArgumentList.Add('-c')
        $psi.ArgumentList.Add($CommandStr)
    }
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.WorkingDirectory = (Get-Location).Path

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    [void]$proc.Start()

    $readTask = $proc.StandardOutput.ReadLineAsync()
    if (-not $readTask.Wait([TimeSpan]::FromSeconds($TimeoutSeconds)) -and -not $proc.HasExited) {
        & taskkill /F /T /PID $proc.Id 2>&1 | Out-Null
    }

    $dump = if (Test-Path $script:DumpEnvFile) { Get-Content -Raw $script:DumpEnvFile } else { '' }
    $actualEnv = [ordered]@{}
    foreach ($key in $ExpectedEnv.PSObject.Properties.Name) {
        if ($dump -match "(?m)^$([regex]::Escape($key))=(.*)$") {
            $actualEnv[$key] = $Matches[1].Trim()
        } else {
            $actualEnv[$key] = $null
        }
    }

    try {
        $proc.StandardInput.WriteLine()
        $proc.StandardInput.Flush()
    } catch {}
    try { $proc.StandardInput.Close() } catch {}

    # Drain to EOF (mirrors Invoke-ShellOut/Invoke-InteractiveShellOut's
    #  own drain-then-exit pattern) so the child never blocks trying to
    #  write more output into an unread pipe before it can actually exit.
    try { [void]$proc.StandardOutput.ReadToEnd() } catch {}
    if (-not $proc.HasExited) { $proc.WaitForExit(2000) | Out-Null }

    return [PSCustomObject]$actualEnv
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

# Test-MatchExpected(matchSpec, output) - true if output contains every
#  substring from at least one os-type group in matchSpec (see n00/n10 -
#  "enumerating variables"/"enumerating paths" - can't do an exact-match
#  comparison since the actual env vars/PATH entries are host-specific,
#  but can check that a known set of substrings is present) - ported
#  from Script.rb's match_expected?. Which group actually applies isn't
#  decided ahead of time (e.g. a native Windows interpreter sees a raw
#  "C:\...;..." PATH, while an msys-runtime-linked one sees it POSIX-
#  translated even on the same machine) - trying every group and
#  accepting whichever one is fully satisfied sidesteps needing to know
#  that distinction in advance. Case-insensitive, same reasoning as
#  Script.rb's version (Windows paths/values are case-insensitive).
function Test-MatchExpected {
    param($MatchSpec, [string]$Output)
    $haystack = $Output.ToLowerInvariant()
    foreach ($prop in $MatchSpec.PSObject.Properties) {
        $allFound = $true
        foreach ($substring in $prop.Value) {
            if (-not $haystack.Contains($substring.ToLowerInvariant())) {
                $allFound = $false
                break
            }
        }
        if ($allFound) { return $true }
    }
    return $false
}

# Test-EnvMatches(expected, output) - plain equality between an env
#  test's expected {var = value} object and the {var = actual_value}
#  object Invoke-EnvShellOut produced - ported from Script.rb's plain
#  Hash `expected == output` comparison for an env test. A PSCustomObject
#  has no built-in structural equality operator (unlike Ruby's Hash), so
#  this compares key-for-key instead.
function Test-EnvMatches {
    param($Expected, $Output)
    $expectedKeys = @($Expected.PSObject.Properties.Name)
    $outputKeys = @($Output.PSObject.Properties.Name)
    if (@(Compare-Object $expectedKeys $outputKeys).Count -gt 0) { return $false }
    foreach ($key in $expectedKeys) {
        if ($Expected.$key -ne $Output.$key) { return $false }
    }
    return $true
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
    Confirm-TestBoxCompiled -Language $language

    $list = @(Get-ChildItem -Path $script:SourceSubdir -Filter "${Task}?.*" | Sort-Object Name | ForEach-Object { $_.Name })
    if ($script:CompiledLanguages -contains $language) {
        # A compiled language's build artifacts live in a separate bin/
        #  (see $script:SourceSubdir) so this is normally a no-op, but
        #  stays as a defensive filter against a stray non-source file
        #  matching the glob - ported from Script.rb's execute().
        $list = @($list | Where-Object { $_.EndsWith(".$language") })
    }

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

            # An "env" test (see n20.setvars.* - "MY_ORDERS set, Hit
            #  Return to continue") doesn't write anything comparable to
            #  stdout/stderr at all - it exports environment variables
            #  and blocks on stdin, so there's nothing to redirect here;
            #  Invoke-EnvShellOut below reads stdout itself to know when
            #  the lesson has reached that blocked read - ported from
            #  Script.rb's execute().
            $isEnvTest = $null -ne $test.PSObject.Properties['env']
            # A "match" test (see n00/n10) captures stdout exactly like a
            #  normal "out" test, but is verified via Test-MatchExpected
            #  instead of a straight string comparison (see below) - the
            #  actual values are host-specific, so an exact expected
            #  string can't exist at all. Ported from Script.rb's
            #  execute() (see is_match_test there).
            $isMatchTest = $null -ne $test.PSObject.Properties['match']

            if ($isEnvTest) {
                $expected = $test.env
            } elseif ($isMatchTest) {
                $redirect = "2> $($script:NullDevice)"
                $expected = $test.match
            } elseif ($test.PSObject.Properties['err']) {
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

            # $invokedName is what actually goes on the command line and
            #  into the $cmd$ substitution below - for an interpreted
            #  language that's just $cmd itself (the source file, handed
            #  to $runner as a data argument); for a compiled one it's
            #  the build artifact's own name (see Get-InvocationName),
            #  since that - not the source file - is what a lesson's own
            #  self-name check would report.
            $invokedName = Get-InvocationName -Cmd $cmd -Language $language
            $isCompiled = $script:CompiledLanguages -contains $language
            $prefix = Get-PathPrefix -Language $language
            # A compiled language's own self-name check would report the
            #  *whole* invoked path (prefix and all) since nothing in the
            #  program strips it - unlike a batch lesson, which strips
            #  any prefix itself (%~nx0), so only compiled languages get
            #  the prefix folded into the $cmd$ substitution here.
            $cmdDisplay = if ($isCompiled) { "$prefix$invokedName" } else { $invokedName }

            # An env/match test's expected value is an object, not a
            #  string carrying a literal "$cmd$"/"$date$" placeholder -
            #  ported from Script.rb's execute() (see is_env_test/
            #  is_match_test there).
            if (-not $isEnvTest -and -not $isMatchTest) {
                $expected = $expected -replace '\$cmd\$', $cmdDisplay
                $expected = $expected -replace '\$date\$', (Get-Date -Format 'MMMM dd, yyyy')
            }

            # $runner is blank for a compiled language - the build
            #  artifact runs itself, unlike an interpreted language's
            #  test file, which is handed to $runner as a data argument.
            $runner = if ($isCompiled) { '' } else { "$(Get-TestBoxCommand -Language $language) $($script:CommandOptions[$language])" }
            $command = "$input $runner $prefix$invokedName $args $redirect"

            if ($isEnvTest) {
                $output = Invoke-EnvShellOut -CommandStr $command -ExpectedEnv $expected
            } elseif (Test-NeedsInteractive -Test $test -Language $language) {
                $output = Invoke-InteractiveShellOut -CommandStr $command -InputLines $inputLines
            } else {
                $output = Invoke-ShellOut -CommandStr $command -StdinText $stdinText
            }

            if ($isEnvTest) {
                $testResult = Test-EnvMatches -Expected $expected -Output $output
            } elseif ($isMatchTest) {
                $testResult = Test-MatchExpected -MatchSpec $expected -Output $output
            } else {
                $testResult = Test-OutputMatches -Test $test -Expected $expected -Output $output
            }

            $result.Results[$key] += [PSCustomObject]@{
                Command    = $command
                Output     = $output
                Expected   = $expected
                TestResult = $testResult
                # raw values differ even when test_result passed via
                #  tolerance - not applicable to an env/match test (no
                #  tolerance types apply there), so its diff is exactly
                #  the inverse of its (already-exact) TestResult, rather
                #  than the PSCustomObject reference-inequality "-ne"
                #  below would otherwise (wrongly) always report.
                Diff       = if ($isEnvTest -or $isMatchTest) { -not $testResult } else { $expected -ne $output }
                Title      = Get-ImplementationTitle -File $cmd
            }

            $result.FinalResult = $result.FinalResult -and $testResult
        }
    }

    return [PSCustomObject]$result
}

# Get-ColoredText(text, color) - text wrapped in raw ANSI escape codes,
#  same convention as Script.rb's own colorize()/red/green/yellow - a
#  plain string, not a Write-Host call. Callers build one complete line
#  as a single string (embedding this where color is wanted) and make
#  exactly one Write-Host call for it - confirmed directly this is
#  necessary, not just style: Write-Host's own -NoNewline is a *host
#  rendering* hint that's silently ignored once the Information stream
#  gets redirected (e.g. Invoke-Psake *>&1 | Out-String, exactly what
#  run_all_tests.ps1 does to capture and parse output) - each Write-Host
#  call becomes its own line regardless of -NoNewline, so what looks
#  like one line interactively ("A0 - Standard Output: [PASS]") was
#  actually landing as three separate lines once captured, corrupting
#  every downstream parse. A single Write-Host call per line sidesteps
#  the whole problem, the same way Script.rb's rake-based colorize()
#  already does (one puts, ANSI codes embedded directly in the string).
#  Respects NO_COLOR (https://no-color.org/, any non-empty value) -
#  returns Text unwrapped when set, satisfying the same "runs cleanly
#  through a plain-text-only parser" need without requiring color to be
#  stripped back out downstream.
function Get-ColoredText {
    param([string]$Text, [string]$Color)
    if (-not [string]::IsNullOrEmpty($env:NO_COLOR)) { return $Text }
    $code = switch ($Color) {
        'Green'  { 32 }
        'Red'    { 31 }
        'Yellow' { 33 }
        default  { 0 }
    }
    "`e[${code}m${Text}`e[0m"
}

function Format-PassFail {
    param([bool]$Passed)
    if ($Passed) { return @{ Text = 'PASS'; Color = 'Green' } }
    return @{ Text = 'FAIL'; Color = 'Red' }
}

# ConvertTo-DisplayableText(value) - ported from Script.rb's report()'s
#  displayable lambda. An env test's expected/output are a PSCustomObject
#  of {var = value} (see Invoke-EnvShellOut), not a string of captured
#  stdout/stderr like every other test type - stringify either shape the
#  same way here rather than assuming "-replace" is always meaningful.
function ConvertTo-DisplayableText {
    param($Value)
    if ($Value -is [string]) { return ($Value -replace "`n", '\n') }
    return ($Value | ConvertTo-Json -Compress)
}

# Write-TestBoxDiff(testCase) - ported from Script.rb's print_diff: prints
#  nothing on a clean pass. On a pass that only succeeded via tolerance
#  (e.g. "precision"), both lines print yellow so the raw difference is
#  still visible. On a real fail, Expected prints green (what it should've
#  been) and Actual prints red (what it was).
function Write-TestBoxDiff {
    param($TestCase)
    if ($TestCase.TestResult -and -not $TestCase.Diff) { return }

    $expectedText = ConvertTo-DisplayableText $TestCase.Expected
    $outputText   = ConvertTo-DisplayableText $TestCase.Output

    if ($TestCase.TestResult) {
        Write-Host "         Expected Output: |$(Get-ColoredText $expectedText 'Yellow')|"
        Write-Host "         Actual Output:   |$(Get-ColoredText $outputText 'Yellow')| (within tolerance)"
    } else {
        Write-Host "         Expected Output: |$(Get-ColoredText $expectedText 'Green')|"
        Write-Host "         Actual Output:   |$(Get-ColoredText $outputText 'Red')|"
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
        Write-Host "${label}: [$(Get-ColoredText 'SKIP' 'Yellow')]$reason"
        return
    }

    $script:Summary.Total++
    if ($Results.FinalResult) { $script:Summary.Pass++ } else { $script:Summary.Fail++ }

    $anyDiff = @($Results.Results.Values | ForEach-Object { $_ } | Where-Object { $_.Diff }).Count -gt 0
    $hasTitles = @($Results.Results.Values | ForEach-Object { $_ } | Where-Object { $_.Title }).Count -gt 0

    $pf = Format-PassFail $Results.FinalResult
    Write-Host "${label}: [$(Get-ColoredText $pf.Text $pf.Color)]"

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
                    Write-Host "      - ${implLabel}: [$(Get-ColoredText $tpf.Text $tpf.Color)]"
                    Write-TestBoxDiff -TestCase $tc
                } else {
                    Write-Host "      - $implLabel ($($entry.Value.Count) testcases):"
                    $count = 1
                    foreach ($tc in $entry.Value) {
                        $tpf = Format-PassFail $tc.TestResult
                        Write-Host "        - Test ${count}: [$(Get-ColoredText $tpf.Text $tpf.Color)]"
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
    $passText = Get-ColoredText "Pass=$($script:Summary.Pass)" 'Green'
    $failText = Get-ColoredText "Fail=$($script:Summary.Fail)" 'Red'
    $skipText = Get-ColoredText "Skip=$($script:Summary.Skip)" 'Yellow'
    Write-Host "Summary: Total=$($script:Summary.Total)  $passText  $failText  $skipText"
}

# Test-TestBoxFailed() - true if any category run so far this session had
#  a lesson FAIL - ported from Script.rb's Script.failed?. The Summary
#  task (see testbox.psake.ps1) throws on this so a failing run actually
#  fails the psake build ($psake.build_success), not just prints red text -
#  Rake gets the equivalent behavior via Script.rb's own
#  `at_exit { exit 1 if Script.failed? }`.
function Test-TestBoxFailed {
    return $script:Summary.Fail -gt 0
}

Export-ModuleMember -Function * -Variable *
