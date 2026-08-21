#!/usr/bin/env bash
# publish.sh <deb-file> [<deb-file> ...] - adds/updates package(s) in the
#  `stable` distribution (see conf/distributions), signing the resulting
#  Release/InRelease with SignWith's own key. reprepro itself has no
#  Windows build - this only runs on Linux (a CI runner, or WSL/a
#  container on this machine); see README.md.
set -euo pipefail
cd "$(dirname "$0")"

[ "$#" -ge 1 ] || { echo "usage: $0 <deb-file> [<deb-file> ...]" >&2; exit 1; }

for deb in "$@"; do
  reprepro includedeb stable "$deb"
done
