#!/usr/bin/env python2
import sys
import getopt

USAGE = """
Usage: %s [-c|-e|-l|-k|-p|-m|-t] [-h|-?]

  -c  Coffee
  -e  Espresso
  -l  Latte
  -k  Machiato
  -p  Capucino
  -m  Mocha
  -t  Tea
  -h  Display this help message
  -?  Display this help message
"""

try:
    opts, args = getopt.getopt(sys.argv[1:], "celkpmth?")
except getopt.GetoptError:
    opts = []

if not opts:
    sys.stderr.write(USAGE % sys.argv[0] + "\n")
    sys.exit(1)

for opt, _ in opts:
    if opt == "-c":
        print "You ordered a Coffee."
        sys.exit(0)
    elif opt == "-e":
        print "You ordered an Espresso."
        sys.exit(0)
    elif opt == "-l":
        print "You ordered a Latte."
        sys.exit(0)
    elif opt == "-k":
        print "You ordered a Machiato."
        sys.exit(0)
    elif opt == "-p":
        print "You ordered a Capucino."
        sys.exit(0)
    elif opt == "-m":
        print "You ordered a Mocha."
        sys.exit(0)
    elif opt == "-t":
        print "You ordered a Tea."
        sys.exit(0)
    elif opt in ("-h", "-?"):
        print USAGE % sys.argv[0]
        sys.exit(0)
