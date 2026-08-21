#!/usr/bin/env bash
# publish.sh <deb-file> [<deb-file> ...] - adds/updates package(s) in the
#  `stable` distribution (see conf/distributions), signing the resulting
#  Release/InRelease with SignWith's own key. reprepro itself has no
#  Windows build - this only runs on Linux (a CI runner, or WSL/a
#  container on this machine); see README.md.
set -euo pipefail

[ "$#" -ge 1 ] || { echo "usage: $0 <deb-file> [<deb-file> ...]" >&2; exit 1; }

# Resolved to absolute paths before cd - a caller-relative path (e.g.
#  pkgbox/deb/act/vendor/x.deb, relative to the repo root) would
#  otherwise resolve against apt-repo/ instead once cd'd there.
debs=()
for deb in "$@"; do
  debs+=("$(realpath "$deb")")
done

cd "$(dirname "$0")"
for deb in "${debs[@]}"; do
  reprepro includedeb stable "$deb"
done
