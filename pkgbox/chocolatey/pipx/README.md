# pipx (Chocolatey)

A Chocolatey port of the upstream Scoop bucket manifest for pipx:
https://github.com/ScoopInstaller/Main/blob/master/bucket/pipx.json

pipx itself isn't distributed as a Windows installer - upstream ships a
single architecture-independent `pipx.pyz` zipapp and expects the host's
own Python to run it. Both the Scoop manifest and this package follow the
same shape: download `pipx.pyz`, generate a `pipx.bat` launcher that
invokes it via `python`/`py`, and put that launcher on PATH.

The Chocolatey package declares `python3` (Python 3.9 or newer) as a
dependency, so Chocolatey installs a suitable Python runtime when needed.

## Layout

| File                          | Purpose                                                              |
| ------------------------------ | --------------------------------------------------------------------- |
| `pipx.nuspec`                  | Package metadata (id, version, license, links)                       |
| `tools/chocolateyinstall.ps1`  | Downloads `pipx.pyz`, verifies its checksum, writes `pipx.bat`, shims it |
| `tools/chocolateyuninstall.ps1`| Removes the shim `chocolateyinstall.ps1` created                     |
| `tools/VERIFICATION.txt`       | How a moderator/user can independently verify the download           |
| `update.ps1`                   | AU script that bumps `$version`/`$checksum` when pipx cuts a release |

## Requirements

pipx needs Python 3.9 or newer. The package declares the Chocolatey
`python3` package as a dependency and then locates either `python` or `py`
on PATH when it creates the launcher.

## Building and testing locally

Run these commands from an elevated PowerShell prompt in this directory:

```powershell
New-Item -ItemType Directory -Force .\vendor
choco pack .\pipx.nuspec --output-directory .\vendor
choco install pipx --source="$PWD\vendor;https://community.chocolatey.org/api/v2/" --version=1.16.7 -y
pipx --version
choco uninstall pipx -y
```

The community source in the install command is needed to resolve the
`python3` dependency; the `pipx` package itself is installed from
`vendor`. Generated `.nupkg` files should remain untracked. This
repository ignores the package's `vendor/` directory.

## Keeping it current: wiring up AU

Chocolatey has no built-in auto-update - packages are just static files
until something edits them. The community convention for that is
[AU (Chocolatey Automatic Packages)](https://github.com/majkinetor/au): a
PowerShell module that reads an `update.ps1` sitting next to the
`.nuspec`, checks upstream for a newer version, and rewrites the package
in place.

`update.ps1` (already added in this directory) defines two functions AU
looks for by name:

- **`au_GetLatest`** - hits `https://api.github.com/repos/pypa/pipx/releases/latest`
  and returns the new version and the `pipx.pyz` asset URL as a hashtable
  (`Version`, `URL32`).
- **`au_SearchReplace`** - tells AU which regex-matched lines in
  `tools/chocolateyinstall.ps1` to rewrite with that hashtable's values.
  Only `$version` and `$checksum` need a rule; `$url` already
  interpolates `$version`, so it's correct as soon as that line is
  rewritten - nothing to keep in sync by hand.

The final line, `update -ChecksumFor 32`, is what actually runs the
check: AU downloads the URL `au_GetLatest` returned, hashes it (pipx
publishes no checksum of its own to trust instead), calls
`au_SearchReplace`, and leaves the package folder edited in place if a
new version was found.

### Running it

1. Install AU once: `choco install au` (or `Install-Module au`).
2. From this directory: `.\update.ps1` - checks pipx's latest release
   against `pipx.nuspec`'s current `<version>`, and if newer, rewrites
   `chocolateyinstall.ps1`'s `$version`/`$checksum` and bumps the nuspec
   version to match.
3. Review the diff, then `choco pack` + push like any other update.

To check many packages at once instead of one at a time, AU also
provides `Update-AUPackages`, which walks a directory of packages (each
with its own `update.ps1`) and runs all of them - typically wired into a
CI schedule (cron on GitHub Actions/AppVeyor, or a nightly scheduled
task) rather than run by hand:

```powershell
$Options = @{ Threads = 5 }
Update-AUPackages -Options $Options
```

This repo doesn't have that scheduler wired up yet - `update.ps1` here
is meant to be run manually (or added to whatever CI already exists) as
new pipx releases come out.
