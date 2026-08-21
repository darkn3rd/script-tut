#!/usr/bin/env bash
# update.sh - checks GitHub for a newer nektos/act release, downloads and
#  verifies the linux/amd64 tarball, stages the binary for nfpm, and
#  rewrites nfpm.yaml's own version: line in place. Not run by `make act`
#  itself (see ../Makefile) - only by a maintainer (or CI) refreshing the
#  pinned version, the deb-side equivalent of chocolatey/pipx's own AU
#  update.ps1.
set -euo pipefail
cd "$(dirname "$0")"

OWNER=nektos
REPO=act
OS=Linux
ARCH=x86_64
TARBALL="act_${OS}_${ARCH}.tar.gz"

# No -m1/head on grep - stopping early would close the pipe while curl
#  is still writing the rest of the response, which curl reports as its
#  own write error (exit 23) under pipefail. /releases/latest returns a
#  single release object, so "tag_name" only ever matches once anyway.
TAG=$(curl -fsSL "https://api.github.com/repos/$OWNER/$REPO/releases/latest" |
  grep '"tag_name"' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
VERSION="${TAG#v}"

BASE_URL="https://github.com/$OWNER/$REPO/releases/download/$TAG"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

curl -fsSL -o "$TMP/$TARBALL" "$BASE_URL/$TARBALL"
curl -fsSL -o "$TMP/checksums.txt" "$BASE_URL/checksums.txt"
(cd "$TMP" && grep " $TARBALL\$" checksums.txt | sha256sum -c -)

mkdir -p vendor
tar -xzf "$TMP/$TARBALL" -C vendor act
chmod 755 vendor/act

sed -i "s/^version: .*/version: \"$VERSION\"/" nfpm.yaml

echo "act updated to $VERSION"
