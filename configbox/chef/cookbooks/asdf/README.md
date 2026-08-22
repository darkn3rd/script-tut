# asdf

A from-scratch, locally-maintained cookbook - not a vendored fork of
[asdf-chef/asdf](https://github.com/asdf-chef/asdf) (Supermarket's only
published `asdf` cookbook), even though the resource names (`asdf_user_install`,
`asdf_plugin`, `asdf_package`) and overall shape intentionally mirror it.

## Why not just depend on the Supermarket cookbook

Checked directly against the actual resource source (not just its docs) before
writing this: `asdf-chef/asdf` was last released in March 2021, entirely
before asdf's own 0.16.0 rewrite (January 2025 - a full port to Go, with
several breaking CLI changes documented at
https://asdf-vm.com/guide/upgrading-to-v0-16.html). Two of its resources are
incompatible with any asdf version this manifest could plausibly pin
(`scriptbox/config/ubuntu2204.yml`'s own `asdf_ver: v0.20.0`):

- `asdf_user_install` bootstraps via `git clone`/`checkout` of the
  `asdf-vm/asdf` repo itself, and sources `asdf.sh`/`completions/asdf.bash`
  from inside that checkout - the old bash-function distribution model.
  Modern asdf ships as a single compiled binary via GitHub Releases (see
  `scriptbox/config/ubuntu2204.yml`'s own `ubuntu22_asdf` script, which this
  cookbook's own `asdf_user_install` mirrors) - there is no `asdf.sh` to
  source, and no repo to check out at all.
- `asdf_package`'s `:global` action shells out to `asdf global <pkg>
  <version>` - a command 0.16.0 removed outright, replaced by `asdf set`
  (confirmed directly on asdf's own upgrade guide, quoted above).

A third, smaller issue: `asdf_plugin`'s `:add` action declares a `git_url`
property but never actually uses it in the command it shells out - it always
falls through to asdf's default plugin registry by short name. That happens
to still resolve correctly for two of this manifest's three plugins (`ruby`,
`groovy`), but not the third: the registry's default `python` plugin is
`danhper/asdf-python.git`, while the manifest explicitly pins
`asdf-community/asdf-python.git` - a different plugin. Silently installing
the wrong one instead of an explicit failure is exactly the kind of thing
this cookbook exists to not do.

## What's actually different here

- `asdf_user_install` downloads the pinned release tarball from
  `github.com/asdf-vm/asdf/releases` and installs the binary to
  `/usr/local/bin/asdf` - no git, no per-repo build dependencies, matching
  `ubuntu22_asdf`'s own script exactly.
- `asdf_package`'s `:global` action runs `asdf set -u <pkg> <version>`, not
  `asdf global` - see `resources/package.rb`'s own comment.
- `asdf_plugin`'s `:add` action passes `git_url` through to `asdf plugin add
  <name> <url>` when given, instead of silently ignoring it.

No per-language build-dependency helpers (the original's own `install_
package_deps` covering R/erlang/nodejs/php/...) - out of scope here on
purpose: `scriptbox/config/ubuntu2204.yml`'s own `gen_scripts` packages
already declare the shared compiler toolchain (`tags: [pyenv, rbenv,
asdf_ruby, asdf_python]`) any language plugin needs to build from source;
duplicating that list inside this cookbook would just be a second place for
it to drift out of sync with the manifest that's already the source of
truth for it.
