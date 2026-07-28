#!/usr/bin/env zsh
# script name captured here, at top level, rather than read as "$0"
#  inside usage() below - zsh (unlike bash) sets $0 to the *function's*
#  name inside a function by default, so "$0" in usage() would print
#  "usage", not this script's actual filename
script_name=$(basename "$0")

usage() {
  cat << EOF

Usage: $script_name [-c|-e|-l|-k|-p|-m|-t] [-h|-?]

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

while getopts "celkpmth?" opt; do
  case $opt in
    c) echo "You ordered a Coffee."; exit 0 ;;
    e) echo "You ordered an Espresso."; exit 0 ;;
    l) echo "You ordered a Latte."; exit 0 ;;
    k) echo "You ordered a Machiato."; exit 0 ;;
    p) echo "You ordered a Capucino."; exit 0 ;;
    m) echo "You ordered a Mocha."; exit 0 ;;
    t) echo "You ordered a Tea."; exit 0 ;;
    h|\?) usage; exit 0 ;;
  esac
done

usage >&2
exit 1
