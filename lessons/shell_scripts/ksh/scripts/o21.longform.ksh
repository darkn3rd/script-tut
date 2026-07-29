#!/usr/bin/env ksh
# GNU getopt (the external /usr/bin/getopt, not the "getopts" builtin -
#  see o20.longform.ksh's manual-parsing alternative) understands both
#  --long and -short options that take a value - it reorders/quotes
#  argv into a shell-safe form that "eval set --" then reloads as the
#  new positional parameters. Note: unlike every other flag here, "-?"
#  can't be made to work as a recognized option character with GNU
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

# plain "arr=()" makes ksh declare a compound variable (typeset -C)
#  instead of an indexed array - "${#arr[@]}" then reports 1, not 0, so
#  the empty-args case below misfires. "typeset -a" forces a real,
#  empty indexed array.
typeset -a names=()
typeset -a counts=()

while true; do
  case "$1" in
    -c|--coffee)    names+=("coffee");    counts+=("$2"); shift 2 ;;
    -e|--espresso)  names+=("espresso");  counts+=("$2"); shift 2 ;;
    -l|--latte)     names+=("latte");     counts+=("$2"); shift 2 ;;
    -k|--macchiato) names+=("macchiato"); counts+=("$2"); shift 2 ;;
    -p|--capucino)  names+=("capucino");  counts+=("$2"); shift 2 ;;
    -m|--mocha)     names+=("mocha");     counts+=("$2"); shift 2 ;;
    -t|--tea)       names+=("tea");       counts+=("$2"); shift 2 ;;
    -h|--help)      usage; exit 0 ;;
    --) shift; break ;;
    *) usage >&2; exit 1 ;;
  esac
done

if [ ${#names[@]} -eq 0 ]; then
  usage >&2
  exit 1
fi

echo ""
echo "You ordered: "
for i in "${!names[@]}"; do
  n="${counts[$i]}"
  name="${names[$i]}"
  suffix=""
  [ "$n" -ne 1 ] && suffix="s"
  echo "* $n ${name}${suffix}"
done
