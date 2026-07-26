#!/usr/bin/env bash
usage() {
  cat << EOF

Usage: $(basename "$0") [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]

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
