#!/usr/bin/env sh
# POSIX sh has no arrays at all - each drink's quantity is tracked as a
#  separate plain variable instead of a hash, and the final list is
#  just built by iterating them in a hardcoded alphabetical-by-key
#  order rather than sorting dynamically.
if [ $# -eq 0 ]; then
  q_coffee=$((RANDOM % 3))
  q_espresso=$((RANDOM % 3))
  q_latte=$((RANDOM % 3))
  q_machiato=$((RANDOM % 3))
  q_capucino=$((RANDOM % 3))
  q_mocha=$((RANDOM % 3))
  q_tea=$((RANDOM % 3))
else
  q_coffee=0; q_espresso=0; q_latte=0; q_machiato=0; q_capucino=0; q_mocha=0; q_tea=0
  for pair in "$@"; do
    key="${pair%%:*}"
    qty="${pair##*:}"
    case "$key" in
      Coffee)    q_coffee=$qty ;;
      Espresso)  q_espresso=$qty ;;
      Latte)     q_latte=$qty ;;
      Machiato)  q_machiato=$qty ;;
      Capucino)  q_capucino=$qty ;;
      Mocha)     q_mocha=$qty ;;
      Tea)       q_tea=$qty ;;
    esac
  done
fi

order=""
for entry in "Capucino:$q_capucino" "Coffee:$q_coffee" "Espresso:$q_espresso" "Latte:$q_latte" "Machiato:$q_machiato" "Mocha:$q_mocha" "Tea:$q_tea"; do
  qty="${entry##*:}"
  if [ "$qty" -ne 0 ]; then
    if [ -z "$order" ]; then
      order="$entry"
    else
      order="$order,$entry"
    fi
  fi
done

export MY_ORDERS="$order"

# Dump the whole environment (plain "KEY=value" lines) to a well-known
#  file for an external observer to inspect while this script is
#  paused below - deleted again once that observer is done and this
#  script is about to exit. Explicit /usr/bin/env, not bare "env": a
#  shell's tracked-alias cache for bare command names can latch onto a
#  *different* env.exe already on PATH (e.g. Git for Windows bundles
#  its own) whose own runtime doesn't see this process's
#  freshly-exported variables - confirmed empirically while debugging
#  this exact lesson under ksh.
/usr/bin/env > dump_env.out

echo "MY_ORDERS set, Hit Return to continue"
read -r _

rm -f dump_env.out
