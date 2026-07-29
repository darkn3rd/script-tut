#!/usr/bin/env python2
import os

# Split the PATH environment variable on its OS-native delimiter and
# print each entry on its own line. A given PATH value never mixes both
# delimiters, so checking for a semicolon first is enough to tell which
# one actually applies.
path = os.environ["PATH"]
delim = ";" if ";" in path else ":"
for entry in path.split(delim):
    print entry
