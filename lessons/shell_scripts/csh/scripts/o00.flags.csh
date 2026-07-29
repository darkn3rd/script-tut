#!/usr/bin/env tcsh
# tcsh has no getopts and no functions (only single-line aliases), so
#  flags are matched by hand against $argv[1], and the usage text is
#  just duplicated at both exit points instead of factored out.
if ($#argv == 1) then
  switch ("$argv[1]")
    case "-c":
      echo "You ordered a Coffee."
      exit 0
    case "-e":
      echo "You ordered an Espresso."
      exit 0
    case "-l":
      echo "You ordered a Latte."
      exit 0
    case "-k":
      echo "You ordered a Machiato."
      exit 0
    case "-p":
      echo "You ordered a Capucino."
      exit 0
    case "-m":
      echo "You ordered a Mocha."
      exit 0
    case "-t":
      echo "You ordered a Tea."
      exit 0
    case "-h":
    case "-?":
      cat << EOF

Usage: $0 [-c|-e|-l|-k|-p|-m|-t] [-h|-?]

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
endif

# Real csh/tcsh has no way to redirect just stderr on its own (only the
#  combined-stream ">&" exists) - /dev/stderr exists but isn't reliably
#  writable under every invocation context here, so this just goes to
#  stdout like the -h/-? case above.
cat << EOF

Usage: $0 [-c|-e|-l|-k|-p|-m|-t] [-h|-?]

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
