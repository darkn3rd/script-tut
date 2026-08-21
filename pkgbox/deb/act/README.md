# act (.deb)

Wraps [nektos/act](https://github.com/nektos/act)'s official Linux/amd64
release binary in a `.deb` (via [nfpm](https://nfpm.goreleaser.com)), as an
alternative to `curl .../install.sh | sudo bash`.

## Updating

`update.sh` checks GitHub for a newer release, downloads and
sha256-verifies the `act_Linux_x86_64.tar.gz` asset, stages the binary into
`vendor/act`, and rewrites `nfpm.yaml`'s own `version:` line in place - the
deb-side equivalent of `pkgbox/chocolatey/pipx`'s own AU `update.ps1`.

```sh
./update.sh
```

## Building

From `pkgbox/deb` (see its own README):

```sh
make act
```

Requires [nfpm](https://nfpm.goreleaser.com/install/)
(`go install github.com/goreleaser/nfpm/v2/cmd/nfpm@latest`). Output lands
in `vendor/act_<version>_amd64.deb`, gitignored - regenerate with `make`.
