#!/usr/bin/env zsh
# Build a hash of drink -> quantity, then export the non-zero entries,
#  sorted by key, as one "Key:Qty,Key:Qty" environment variable. With
#  no arguments, quantities are randomly generated (0-2) for every
#  drink; the test harness always supplies fixed "Key:Qty" arguments
#  instead, so the result stays deterministic to check.
declare -A drinks=(
  [Capucino]=0
  [Coffee]=0
  [Espresso]=0
  [Latte]=0
  [Machiato]=0
  [Mocha]=0
  [Tea]=0
)

# zsh has no "${!array[@]}" (bash's "list the keys" syntax) - that's a
#  bad substitution here; the zsh equivalent is the "(k)" parameter flag
if [ $# -eq 0 ]; then
  for key in "${(k)drinks[@]}"; do
    drinks[$key]=$((RANDOM % 3))
  done
else
  for pair in "$@"; do
    key="${pair%%:*}"
    qty="${pair##*:}"
    drinks[$key]=$qty
  done
fi

order=""
for key in $(printf '%s\n' "${(k)drinks[@]}" | sort); do
  qty="${drinks[$key]}"
  if [ "$qty" -ne 0 ]; then
    if [ -z "$order" ]; then
      order="$key:$qty"
    else
      order="$order,$key:$qty"
    fi
  fi
done

export MY_ORDERS="$order"

# Dump the whole environment (plain "KEY=value" lines - "env", not
#  "export", which would print bash's own "declare -x KEY=..." syntax
#  instead) to a well-known file for an external observer to inspect
#  while this script is paused below - deleted again once that observer
#  is done and this script is about to exit. Explicit /usr/bin/env, not
#  bare "env": a shell's tracked-alias cache for bare command names can
#  latch onto a *different* env.exe already on PATH (e.g. Git for
#  Windows bundles its own) whose own runtime doesn't see this
#  process's freshly-exported variables - confirmed empirically while
#  debugging this exact lesson under ksh.
/usr/bin/env > dump_env.out

echo "MY_ORDERS set, Hit Return to continue"
read -r _

rm -f dump_env.out
