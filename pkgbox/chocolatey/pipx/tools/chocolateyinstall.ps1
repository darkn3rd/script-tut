$ErrorActionPreference = 'Stop'

$packageName = 'pipx'
$toolsDir    = Split-Path -Parent $MyInvocation.MyCommand.Definition
$version     = '1.16.7'
$url         = "https://github.com/pypa/pipx/releases/download/$version/pipx.pyz"
$checksum    = '302633d0061e0ab4269257501cbe1338cde5f00f22f121543706624aada0145e'
$pyzPath     = Join-Path $toolsDir 'pipx.pyz'

Get-ChocolateyWebFile -PackageName $packageName `
  -FileFullPath $pyzPath `
  -Url $url `
  -Checksum $checksum `
  -ChecksumType 'sha256'

# pipx.pyz is a zipapp, not something Chocolatey's own shimgen can launch
#  directly - same problem the upstream Scoop manifest's own pre_install
#  block solves with a generated .bat wrapper (see bucket/pipx.json's
#  pre_install/bin keys, ported here as-is). Try `python` then `py`,
#  same order as upstream.
$pythonCmd = $null
foreach ($candidate in @('python', 'py')) {
    if (Get-Command $candidate -ErrorAction SilentlyContinue) {
        $pythonCmd = $candidate
        break
    }
}
if (-not $pythonCmd) {
    throw 'pipx requires Python. Install Python (e.g. `choco install python`) and ensure it is on PATH, then reinstall this package.'
}

$launcherPath = Join-Path $toolsDir 'pipx.bat'
Set-Content -Path $launcherPath -Value "@$pythonCmd `"%~dp0pipx.pyz`" %*" -Encoding ASCII

# Chocolatey only auto-shims .exe files dropped in tools\ - pipx.bat
#  needs an explicit shim, the Install-BinFile/Uninstall-BinFile pair
#  being Chocolatey's own equivalent of Scoop's `"bin": "pipx.bat"`.
Install-BinFile -Name 'pipx' -Path $launcherPath
