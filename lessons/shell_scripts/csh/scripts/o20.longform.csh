#!/usr/bin/env tcsh
# tcsh has no getopts, no functions (only single-line aliases), and no
#  way to make a flag optionally take a following value - so this is
#  parsed entirely by hand: each drink case builds a "s" suffix once
#  from its own quantity argument (rather than writing out the full
#  singular and plural string separately), then shifts past both the
#  flag and its value.
set orders = ()

while ($#argv > 0)
  switch ("$argv[1]")
    case "--coffee":
    case "-c":
      set suffix = ""
      if ("$argv[2]" != "1") set suffix = "s"
      set orders = ($orders:q "$argv[2] coffee$suffix")
      shift; shift
      breaksw
    case "--espresso":
    case "-e":
      set suffix = ""
      if ("$argv[2]" != "1") set suffix = "s"
      set orders = ($orders:q "$argv[2] espresso$suffix")
      shift; shift
      breaksw
    case "--latte":
    case "-l":
      set suffix = ""
      if ("$argv[2]" != "1") set suffix = "s"
      set orders = ($orders:q "$argv[2] latte$suffix")
      shift; shift
      breaksw
    case "--macchiato":
    case "-k":
      set suffix = ""
      if ("$argv[2]" != "1") set suffix = "s"
      set orders = ($orders:q "$argv[2] macchiato$suffix")
      shift; shift
      breaksw
    case "--capucino":
    case "-p":
      set suffix = ""
      if ("$argv[2]" != "1") set suffix = "s"
      set orders = ($orders:q "$argv[2] capucino$suffix")
      shift; shift
      breaksw
    case "--mocha":
    case "-m":
      set suffix = ""
      if ("$argv[2]" != "1") set suffix = "s"
      set orders = ($orders:q "$argv[2] mocha$suffix")
      shift; shift
      breaksw
    case "--tea":
    case "-t":
      set suffix = ""
      if ("$argv[2]" != "1") set suffix = "s"
      set orders = ($orders:q "$argv[2] tea$suffix")
      shift; shift
      breaksw
    case "--help":
    case "-h":
    case "-?":
      cat << EOF

Usage: $0 [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]

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
      exit 0
    default:
      # Real csh/tcsh has no way to redirect just stderr on its own
      #  (only the combined-stream ">&" exists) - /dev/stderr exists but
      #  isn't reliably writable under every invocation context here, so
      #  this just goes to stdout like the --help case above.
      cat << EOF

Usage: $0 [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]

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
      exit 1
  endsw
end

if ($#orders == 0) then
  cat << EOF

Usage: $0 [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]

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
  exit 1
endif

echo ""
echo "You ordered: "
foreach order ($orders:q)
  echo "* $order"
end
