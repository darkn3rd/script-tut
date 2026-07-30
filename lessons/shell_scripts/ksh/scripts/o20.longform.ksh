#!/usr/bin/env ksh
# getopts has no concept of long-form ("--coffee") flags at all, and no
#  way to make a flag optionally take a following value - so this is
#  parsed entirely by hand, checking each argument against both its
#  long and short spelling, and consuming the next argument as that
#  flag's quantity.
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

# plain "arr=()" makes ksh declare a compound variable (typeset -C)
#  instead of an indexed array - "${#arr[@]}" then reports 1, not 0, so
#  the empty-args case below misfires. "typeset -a" forces a real,
#  empty indexed array.
typeset -a names=()
typeset -a counts=()

while [ $# -gt 0 ]; do
  case "$1" in
    --coffee|-c)    names+=("coffee");    counts+=("$2"); shift 2 ;;
    --espresso|-e)  names+=("espresso");  counts+=("$2"); shift 2 ;;
    --latte|-l)     names+=("latte");     counts+=("$2"); shift 2 ;;
    --macchiato|-k) names+=("macchiato"); counts+=("$2"); shift 2 ;;
    --capucino|-p)  names+=("capucino");  counts+=("$2"); shift 2 ;;
    --mocha|-m)     names+=("mocha");     counts+=("$2"); shift 2 ;;
    --tea|-t)       names+=("tea");       counts+=("$2"); shift 2 ;;
    --help|-h|-\?)  usage; exit 0 ;;
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
  if [ "$n" -eq 1 ]; then
    echo "* $n $name"
  else
    echo "* $n ${name}s"
  fi
done
