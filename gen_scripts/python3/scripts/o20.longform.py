#!/usr/bin/env python3
import sys

USAGE = """
Usage: %s [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]

  --coffee,    -c N  Coffee
  --espresso,  -e N  Espresso
  --latte,     -l N  Latte
  --macchiato, -k N  Machiato
  --capucino,  -p N  Capucino
  --mocha,     -m N  Mocha
  --tea,       -t N  Tea
  --help,      -h    Display this help message
  -?                 Display this help message
"""

# argparse can't easily be told "collect flags in the order they were
#  given, allowing repeats" - it's built around a single fixed
#  destination per flag - so this is parsed by hand instead, matching
#  the technique used across every other language's o20 lesson.
FLAGS = {
    "--coffee": "coffee", "-c": "coffee",
    "--espresso": "espresso", "-e": "espresso",
    "--latte": "latte", "-l": "latte",
    "--macchiato": "macchiato", "-k": "macchiato",
    "--capucino": "capucino", "-p": "capucino",
    "--mocha": "mocha", "-m": "mocha",
    "--tea": "tea", "-t": "tea",
}

args = sys.argv[1:]
orders = []
i = 0
while i < len(args):
    arg = args[i]
    if arg in ("--help", "-h", "-?"):
        print(USAGE % sys.argv[0])
        sys.exit(0)
    elif arg in FLAGS:
        name = FLAGS[arg]
        n = int(args[i + 1])
        orders.append("%d %s" % (n, name if n == 1 else name + "s"))
        i += 2
    else:
        print(USAGE % sys.argv[0], file=sys.stderr)
        sys.exit(1)

if not orders:
    print(USAGE % sys.argv[0], file=sys.stderr)
    sys.exit(1)

print()
print("You ordered: ")
for order in orders:
    print("* " + order)
