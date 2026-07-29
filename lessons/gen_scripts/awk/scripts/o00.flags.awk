#!/usr/bin/env gawk -f
# awk has no getopts and ARGV[0] is always the interpreter's own name
#  ("gawk"), never the script file - "invoked_as" is supplied by the
#  test harness itself via "-v invoked_as=..." (see testbox/Script.rb)
#  standing in for a real argv[0]. Flags are matched by hand against
#  ARGV[1].
BEGIN {
  usage = "\n" \
          "Usage: " invoked_as " [-c|-e|-l|-k|-p|-m|-t] [-h|-?]\n" \
          "\n" \
          "  -c  Coffee\n" \
          "  -e  Espresso\n" \
          "  -l  Latte\n" \
          "  -k  Machiato\n" \
          "  -p  Capucino\n" \
          "  -m  Mocha\n" \
          "  -t  Tea\n" \
          "  -h  Display this help message\n" \
          "  -?  Display this help message\n" \
          "\n"

  if (ARGC != 2) {
    printf "%s", usage > "/dev/stderr"
    exit 1
  }

  flag = ARGV[1]
  if (flag == "-c") { print "You ordered a Coffee."; exit 0 }
  else if (flag == "-e") { print "You ordered an Espresso."; exit 0 }
  else if (flag == "-l") { print "You ordered a Latte."; exit 0 }
  else if (flag == "-k") { print "You ordered a Machiato."; exit 0 }
  else if (flag == "-p") { print "You ordered a Capucino."; exit 0 }
  else if (flag == "-m") { print "You ordered a Mocha."; exit 0 }
  else if (flag == "-t") { print "You ordered a Tea."; exit 0 }
  else if (flag == "-h" || flag == "-?") { printf "%s", usage; exit 0 }
  else { printf "%s", usage > "/dev/stderr"; exit 1 }
}
