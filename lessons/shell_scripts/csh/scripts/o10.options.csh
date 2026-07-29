#!/usr/bin/env tcsh
# tcsh has no getopts and no functions (only single-line aliases), so
#  flags are matched by hand against each element of $argv, and the
#  usage text is just duplicated at both exit points instead of
#  factored out.
set orders = ()
foreach flag ($argv)
  switch ("$flag")
    case "-c":
      set orders = ($orders coffee)
      breaksw
    case "-e":
      set orders = ($orders espresso)
      breaksw
    case "-l":
      set orders = ($orders latte)
      breaksw
    case "-k":
      set orders = ($orders macchiato)
      breaksw
    case "-p":
      set orders = ($orders capucino)
      breaksw
    case "-m":
      set orders = ($orders mocha)
      breaksw
    case "-t":
      set orders = ($orders tea)
      breaksw
    case "-h":
    case "-?":
      cat << EOF

Usage: $0 [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]

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
      exit 0
  endsw
end

if ($#orders == 0) then
  # Real csh/tcsh has no way to redirect just stderr on its own (only
  #  the combined-stream ">&" exists) - /dev/stderr exists but isn't
  #  reliably writable under every invocation context here, so this
  #  just goes to stdout like the -h/-? case above.
  cat << EOF

Usage: $0 [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]

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
  exit 1
endif

echo ""
echo "You ordered: "
foreach drink ($orders)
  echo "* $drink"
end
