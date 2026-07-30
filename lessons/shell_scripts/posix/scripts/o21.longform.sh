#!/usr/bin/env sh
# GNU getopt (the external /usr/bin/getopt, not the "getopts" builtin -
#  see o20.longform.sh's manual-parsing alternative) understands both
#  --long and -short options that take a value - it reorders/quotes
#  argv into a shell-safe form that "eval set --" then reloads as the
#  new positional parameters. POSIX sh also has no arrays at all, so
#  the result is built up as one growing multi-line string instead of a
#  list, same as o20.longform.sh. Note: unlike every other flag here,
#  "-?" can't be made to work as a recognized option character with GNU
#  getopt (it's treated as a parse error no matter what), so it falls
#  through to the same usage text via the generic-error path instead of
#  the --help path.
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

PARSED=$(getopt -o 'c:e:l:k:p:m:t:h' --long 'coffee:,espresso:,latte:,macchiato:,capucino:,mocha:,tea:,help' -n "$(basename "$0")" -- "$@") || { usage >&2; exit 1; }
eval set -- "$PARSED"

result=""
count=0

while true; do
  case "$1" in
    -c|--coffee)    name="coffee";    n="$2"; shift 2 ;;
    -e|--espresso)  name="espresso";  n="$2"; shift 2 ;;
    -l|--latte)     name="latte";     n="$2"; shift 2 ;;
    -k|--macchiato) name="macchiato"; n="$2"; shift 2 ;;
    -p|--capucino)  name="capucino";  n="$2"; shift 2 ;;
    -m|--mocha)     name="mocha";     n="$2"; shift 2 ;;
    -t|--tea)       name="tea";       n="$2"; shift 2 ;;
    -h|--help)      usage; exit 0 ;;
    --) shift; break ;;
    *) usage >&2; exit 1 ;;
  esac

  suffix=""
  [ "$n" -ne 1 ] && suffix="s"
  line="* $n ${name}${suffix}"

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
