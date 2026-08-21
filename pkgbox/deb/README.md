# Debian Packages

This area is for building `.deb` packages that wrap a prebuilt upstream
binary release - an alternative to a `curl | sudo bash` install script.
Uses [nfpm](https://nfpm.goreleaser.com), a lightweight packager that
builds a `.deb` directly from a YAML spec, no `debian/` source-packaging
tree needed. Packages build locally into each package's own `vendor/`,
gitignored.

See `apt-repo/` for actually publishing these somewhere `apt install`
can reach - a prototype signed apt repo meant for GitHub Pages, not a
PPA (source-only, wouldn't accept a prebuilt binary anyway).

## Updating

nfpm has no update mechanism of its own; each package supplies its own
`update.sh`, the deb-side equivalent of `pkgbox/chocolatey`'s AU
`update.ps1` convention - it checks upstream for a newer release, verifies
its checksum, and rewrites that package's own `nfpm.yaml` in place.

## Instructions

### Building packages with GNU Make

The Makefile discovers each package directory that contains an
`nfpm.yaml` file. For example, `act/nfpm.yaml` creates the `act` target.

```sh
# Show discovered package targets.
make list

# Build one package into act/vendor/.
make act

# Build every discovered package into its own vendor/ directory.
make

# Run update.sh for one package that has one.
make update-act

# Run update.sh for every package that has one.
make update
```

Package output under `*/vendor/` is generated locally and ignored by Git.

Requires [nfpm](https://nfpm.goreleaser.com/install/) on `PATH`
(`go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest`).

### Building without GNU Make

#### act example

```sh
cd pkgbox/deb/act
./update.sh
nfpm pkg --config nfpm.yaml --target vendor/ --packager deb
```
