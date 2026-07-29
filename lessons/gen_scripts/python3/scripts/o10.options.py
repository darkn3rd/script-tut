#!/usr/bin/env python3
import sys
import getopt

USAGE = """
Usage: %s [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]

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

FLAGS = {
    "-c": "coffee",
    "-e": "espresso",
    "-l": "latte",
    "-k": "macchiato",
    "-p": "capucino",
    "-m": "mocha",
    "-t": "tea",
}

try:
    opts, args = getopt.getopt(sys.argv[1:], "celkpmth?")
except getopt.GetoptError:
    opts = []

for opt, _ in opts:
    if opt in ("-h", "-?"):
        print(USAGE % sys.argv[0])
        sys.exit(0)

orders = [FLAGS[opt] for opt, _ in opts if opt in FLAGS]

if not orders:
    print(USAGE % sys.argv[0], file=sys.stderr)
    sys.exit(1)

print()
print("You ordered: ")
for drink in orders:
    print("* " + drink)
