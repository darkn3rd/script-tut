# Chocolatey Packages

This area is for building Chocolatey packages. 

## Updating 

Chocolatey has no update mechanism, as the packages themselves are static until they are manually edited.  The community standard for updating packages is AU (majkinetor/au), a PowerShell module that looks for an `update.ps1` next to the `.nuspec` and exptect two functions.

1. `au_GetLatest` — hits project's GitHub releases API, returns the new version + the artifact's asset URL.
2. `au_SearchReplace` — regex rules for which lines in chocolateyinstall.ps1 to rewrite with that data.

## Instructions

### Building packages with GNU Make

The Makefile discovers each package directory that contains a matching
`.nuspec` file. For example, `pipx/pipx.nuspec` creates the `pipx` target.
Run these commands from `pkgbox/chocolatey`:

```sh
# Show discovered package targets.
make list

# Build one package into pipx/vendor/.
make pipx

# Build every discovered package into its own vendor/ directory.
make

# Run AU for one package that contains update.ps1.
make update-pipx

# Run AU for every package that contains update.ps1.
make update

# Push one already-built package to the public Chocolatey Community
# Repository. Only ever per-package, by name - there is deliberately no
# bare `publish` target that pushes everything at once.
make publish-pipx
```

Package output under `*/vendor/` is generated locally and ignored by Git.

The update targets require the AU PowerShell module. Install it once with
`choco install au`. Each `update-<package>` target changes into the package
directory before running its `update.ps1`, allowing AU's relative search-and-
replace paths to resolve correctly. AU updates the package source files; run
`make <package>` afterward to build the updated `.nupkg`.

`publish-<package>` pushes `<package>/vendor/<package>.<nuspec version>.nupkg`
straight to `https://push.chocolatey.org/` - public and moderated, but
visible the moment it's pushed, so it's worth running deliberately, not
as part of a routine build. Requires an API key configured once beforehand
(`choco apikey add --source https://push.chocolatey.org/ --key <key>`) and
the package already built (`make <package>` first).

### Building without GNU Make

#### pipx example

```pwsh
$repo = "/path/to/script-tut"
$target = "pipx"
Set-Location "$repo\pkgbox\chocolatey\$target"

# create directory if this doesn't exist
New-Item -ItemType Directory -Force '.\vendor'

# vendor install package
choco pack '.\pipx.nuspec' --output-directory="'.\vendor'"

# install using elevated privileges
gsudo choco install pipx --source="'.\vendor'" --version='1.16.7' --yes

# verify results
pipx --version
```

## Searching for Packages

```pwsh
choco search pipx --exact --source=https://community.chocolatey.org/api/v2/
```
