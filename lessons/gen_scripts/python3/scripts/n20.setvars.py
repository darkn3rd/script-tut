#!/usr/bin/env python3
import os
import random
import sys

drinks = {
    "Capucino": 0,
    "Coffee": 0,
    "Espresso": 0,
    "Latte": 0,
    "Machiato": 0,
    "Mocha": 0,
    "Tea": 0,
}

if len(sys.argv) == 1:
    for key in drinks:
        drinks[key] = random.randint(0, 2)
else:
    for pair in sys.argv[1:]:
        key, qty = pair.split(":", 1)
        drinks[key] = int(qty)

order = ",".join(
    "%s:%d" % (key, drinks[key])
    for key in sorted(drinks)
    if drinks[key] != 0
)

os.environ["MY_ORDERS"] = order

# Dump the whole environment (plain "KEY=value" lines) to a well-known
#  file for an external observer to inspect while this script is
#  paused below - deleted again once that observer is done and this
#  script is about to exit.
with open("dump_env.out", "w") as f:
    for key, value in os.environ.items():
        f.write("%s=%s\n" % (key, value))

# Explicit flush - stdout is block-buffered (not line-buffered) once
#  it's a pipe rather than a real terminal, so without this the prompt
#  below might never actually reach the test harness waiting to read it.
print("MY_ORDERS set, Hit Return to continue")
sys.stdout.flush()
input()

os.remove("dump_env.out")
