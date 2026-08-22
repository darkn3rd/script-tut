# publish.ps1 -Package <name> - pushes <name>/vendor/<name>.<nuspec
#  version>.nupkg to the public Chocolatey Community Repository. A real
#  script, not an inline Makefile one-liner - the Makefile's own recipe
#  needs to run under whatever shell `make` picks (cmd.exe on plain
#  Windows, sh/bash under Git Bash/MSYS2), and $(...)/sed only work under
#  the latter (confirmed directly: cmd.exe passed the literal, unexpanded
#  $(sed ...) text straight to choco push as a bogus path). -File with a
#  plain argument sidesteps that entirely - no nested quoting for either
#  shell to misinterpret.
#
# Requires an API key already configured (choco apikey add --source
#  https://push.chocolatey.org/ --key <key>) and the package already
#  built (make <name> first - this does not build it for you).
param(
    [Parameter(Mandatory)]
    [string]$Package
)

$nuspecPath = Join-Path $Package "$Package.nuspec"
[xml]$nuspec = Get-Content $nuspecPath
$version = $nuspec.package.metadata.version

$nupkgPath = Join-Path $Package "vendor\$Package.$version.nupkg"
if (-not (Test-Path $nupkgPath)) {
    throw "Package not built: $nupkgPath (run: make $Package)"
}

choco push $nupkgPath --source https://push.chocolatey.org/
