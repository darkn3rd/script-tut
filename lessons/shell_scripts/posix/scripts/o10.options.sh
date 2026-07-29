#!/usr/bin/env sh
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

orders=""
count=0
while getopts "celkpmth?" opt; do
  case $opt in
    c) orders="$orders coffee";    count=$((count + 1)) ;;
    e) orders="$orders espresso";  count=$((count + 1)) ;;
    l) orders="$orders latte";     count=$((count + 1)) ;;
    k) orders="$orders macchiato"; count=$((count + 1)) ;;
    p) orders="$orders capucino";  count=$((count + 1)) ;;
    m) orders="$orders mocha";     count=$((count + 1)) ;;
    t) orders="$orders tea";       count=$((count + 1)) ;;
    h|\?) usage; exit 0 ;;
  esac
done

if [ $count -eq 0 ]; then
  usage >&2
  exit 1
fi

echo ""
echo "You ordered: "
for drink in $orders; do
  echo "* $drink"
done
