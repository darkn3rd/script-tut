# apt-repo

A signed apt repository (via [reprepro](https://salsa.debian.org/debian/reprepro))
for `.deb` packages built in `../` (currently just `../act`), meant to be
served as static files from GitHub Pages so `apt install`/`apt upgrade`
work against it directly - no PPA (source-only, wouldn't accept a
prebuilt binary anyway) and no third-party hosted-repo service.

**Status: prototype, not published.** `conf/`, `publish.sh`, and the
production key below are real; nothing has actually been signed or
pushed anywhere yet. The GPG signing mechanics (detached + clearsigned
`Release`) were verified directly against an isolated throwaway key
before generating the real one - the `reprepro` step itself needs Linux
(it has no Windows build) and hasn't been run end-to-end on this machine.

## How it fits together

1. `../act`'s own `update.sh`/`nfpm` build a `.deb` (see `../README.md`).
2. `publish.sh` runs `reprepro includedeb stable <deb>`, which adds the
   package into `dists/`/`pool/` here and signs `Release`/`InRelease`
   with the key named in `conf/distributions`' own `SignWith:`.
3. `dists/`, `pool/`, and the exported public key get served over HTTP -
   GitHub Pages, pointed at this directory's own output.

## Production key

Generated 2026-08-21, RSA 4096, expires 2028-08-20, `Joaquin Menchaca
<suavecali@yahoo.com>`, fingerprint `BEF3D87FB85D3FB5A6EAE41F92668237EBFEFD38`
(also `conf/distributions`' own `SignWith:`). `%no-protection` (no
passphrase) is deliberate, not an oversight - non-interactive CI signing
can't prompt for one; the key's protection is GitHub's own secret-access
controls instead.

(A first attempt at this key, fingerprint `52AD2A6BA89571CF850AB33B701BA60633BB6B27`,
was generated and then deleted before it was confirmed saved - dead,
never used anywhere, safe to ignore if it turns up in old conversation
history.)

`public.asc` (this directory) is tracked in the repo - stable public
identity material, not build output. The private key and revocation
certificate were handed to Joaquin directly, not committed anywhere:

- **Private key** → add as the repo's `APT_SIGNING_KEY` Actions secret
  (Settings > Secrets and variables > Actions > New repository secret) -
  the workflow reads it from there, it should never touch this repo.
- **Revocation certificate** → back up somewhere safe (password manager,
  offline storage). It's the only way to revoke this key if it's ever
  lost or compromised - without it, a compromised key can't be cleanly
  un-trusted, only replaced.

To generate a *different* key later (rotation, or starting over):

```sh
gpg --batch --generate-key - <<'EOF'
%no-protection
Key-Type: RSA
Key-Length: 4096
Name-Real: Joaquin Menchaca
Name-Email: <address>
Expire-Date: 2y
%commit
EOF
gpg --armor --export-secret-keys <FINGERPRINT>   # -> APT_SIGNING_KEY secret
gpg --armor --export <FINGERPRINT>               # -> public.asc
```

## Publishing (manual, until CI is wired up)

Requires Linux (reprepro has no Windows build) - a CI runner, WSL, or a
container on this machine:

```sh
sudo apt-get install reprepro
./publish.sh ../act/vendor/act_*.deb
```

`db/`, `dists/`, and `pool/` are generated here and gitignored - the same
"fetched/built on demand, not this repo's own source" reasoning as every
other `vendor/` directory in this repo.

## Hosting on GitHub Pages

`.github/workflows/publish-apt-repo.yml` is a draft that automates this
(build the `.deb`, sign, push `dists/`+`pool/`+the public key to a
`gh-pages` branch) but is `workflow_dispatch`-only and needs the
`APT_SIGNING_KEY` secret set first - review it before adding a real
trigger. GitHub Pages itself (Settings > Pages > Deploy from a branch >
`gh-pages`) isn't enabled - that's a repo-setting change to make
deliberately, not something to flip on by running a workflow.

## Using the repo (once published)

```sh
curl -fsSL https://darkn3rd.github.io/script-tut/public.asc | \
  sudo gpg --dearmor -o /usr/share/keyrings/script-tut-apt.gpg
echo "deb [signed-by=/usr/share/keyrings/script-tut-apt.gpg] \
  https://darkn3rd.github.io/script-tut stable main" | \
  sudo tee /etc/apt/sources.list.d/script-tut.list
sudo apt-get update
sudo apt-get install act
```
