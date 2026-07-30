#!/usr/bin/env sh
# getopts has no concept of long-form ("--coffee") flags at all, no way
#  to make a flag optionally take a following value, and POSIX sh has
#  no arrays at all - so this is parsed entirely by hand, checking each
#  argument against both its long and short spelling, consuming the
#  next argument as that flag's quantity, and building up the result as
#  one growing multi-line string instead of a list.
usage() {
  cat << EOF

Usage: $(basename "$0") [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]

  --coffee,    -c N  Coffee
  --espresso,  -e N  Espresso
  --latte,     -l N  Latte
  --macchiato, -k N  Machiato
  --capucino,  -p N  Capucino
  --mocha,     -m N  Mocha
  --tea,       -t N  Tea
  --help,      -h    Display this help message
  -?                 Display this help message

EOF
}

result=""
count=0

while [ $# -gt 0 ]; do
  case "$1" in
    --coffee|-c)    name="coffee";    n="$2"; shift 2 ;;
    --espresso|-e)  name="espresso";  n="$2"; shift 2 ;;
    --latte|-l)     name="latte";     n="$2"; shift 2 ;;
    --macchiato|-k) name="macchiato"; n="$2"; shift 2 ;;
    --capucino|-p)  name="capucino";  n="$2"; shift 2 ;;
    --mocha|-m)     name="mocha";     n="$2"; shift 2 ;;
    --tea|-t)       name="tea";       n="$2"; shift 2 ;;
    --help|-h|-\?)  usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac

  if [ "$n" -eq 1 ]; then
    line="* $n $name"
  else
    line="* $n ${name}s"
  fi

  if [ -z "$result" ]; then
    result="$line"
  else
    result="$result
$line"
  fi
  count=$((count + 1))
done

if [ $count -eq 0 ]; then
  usage >&2
  exit 1
fi

echo ""
echo "You ordered: "
echo "$result"
