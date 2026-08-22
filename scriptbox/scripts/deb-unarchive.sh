#!/bin/bash
set -euo pipefail

usage() {
  echo "usage: $(basename "$0") <package.deb>" >&2
  exit 1
}

[ $# -eq 1 ] || usage
deb=$1

[ -f "$deb" ] || { echo "no such file: $deb" >&2; exit 1; }

base=$(basename "$deb")
outdir=${base%.deb}

if [ -e "$outdir" ]; then
  echo "refusing to overwrite existing path: $outdir" >&2
  exit 1
fi

mkdir -p "$outdir"

# macOS BSD ar workaround 
# -----------------------
# * Context: Real .deb files (built by dpkg-deb, using GNU ar) store 
#     member names with a trailing '/' terminator (e.g. "debian-binary/").
#     GNU ar's own `ar x`/`ar p <name>` strip that before matching
# * Problem: macOS's ar (BSD/cctools) does not strip traling '/'; 
#     BSD ar -x/-p *name lookup* can't find a member by that same
#     name, and `ar x` with no name filter at all silently extracts
#     nothing
# * Solution: Use `ar tv` to slice blob back into individually named files
#     without acking `ar` to look anything up by name on either platform
blob=$(mktemp)
trap 'rm -f "$blob"' EXIT
ar p "$deb" > "$blob"

offset=0
while read -r size name; do
  # GNU ar's own trailing '/' name terminator - see above. A no-op
  # where it's absent (macOS's `ar tv` doesn't add one).
  name=${name%/}
  tail -c "+$((offset + 1))" "$blob" | head -c "$size" > "$outdir/$name"
  offset=$((offset + size))
done < <(ar tv "$deb" | awk '{print $3, $NF}')

# control.tar.*/data.tar.* -> each unpacked into its own subdirectory
# named after itself with every extension stripped (control.tar.gz ->
# control/, data.tar.xz -> data/), same convention as the outer
# mypackage.deb -> mypackage/ directory. debian-binary/_gpgorigin are
# left alone - plain files, not archives.
for member in "$outdir"/*.tar.*; do
  [ -e "$member" ] || continue
  name=$(basename "$member")
  dir=${name%%.*}
  mkdir "$outdir/$dir"
  tar xf "$member" -C "$outdir/$dir"
  rm "$member"
done

echo "extracted $deb -> $outdir/"
