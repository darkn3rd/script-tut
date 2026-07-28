#!/usr/bin/env zsh
# script name captured here, at top level, rather than read as "$0"
#  inside usage() below - zsh (unlike bash) sets $0 to the *function's*
#  name inside a function by default, so "$0" in usage() would print
#  "usage", not this script's actual filename
script_name=$(basename "$0")

usage() {
  cat << EOF

Usage: $script_name [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]

  -c  Coffee
  -e  Espresso
  -l  Latte
  -k  Machiato
  -p  Capucino
  -m  Mocha
  -t  Tea
  -h  Display this help message
  -?  Display this help message

EOF
}

orders=()
while getopts "celkpmth?" opt; do
  case $opt in
    c) orders+=("coffee") ;;
    e) orders+=("espresso") ;;
    l) orders+=("latte") ;;
    k) orders+=("macchiato") ;;
    p) orders+=("capucino") ;;
    m) orders+=("mocha") ;;
    t) orders+=("tea") ;;
    h|\?) usage; exit 0 ;;
  esac
done

if [ ${#orders[@]} -eq 0 ]; then
  usage >&2
  exit 1
fi

echo ""
echo "You ordered: "
for drink in "${orders[@]}"; do
  echo "* $drink"
done
