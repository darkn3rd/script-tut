$ErrorActionPreference = 'Stop'

# The shim created by Install-BinFile in chocolateyinstall.ps1 is not
#  removed automatically - Chocolatey only cleans up shims it generated
#  itself from a tools\*.exe.
Uninstall-BinFile -Name 'pipx'
