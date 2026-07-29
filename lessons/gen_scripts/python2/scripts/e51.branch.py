#!/usr/bin/env python2
import sys  # system library for standard input and output
import re   # regular expresion library

sys.stdout.write("Input a character: ")    # output prompt
keypress = sys.stdin.read(1)               # read one character

# python 2 has no switch/match statement (match/case with guard clauses
#  is python 3.10+, see python3's e50 lesson) - a list of (pattern,
#  result) pairs tested in order is the multiway equivalent, same idea
#  as e41.branch.py's dict dispatch, but ordered since patterns can
#  overlap and dict keys can't be regexes
options = [
  ("[a-z]", "Lowercase letter"),
  ("[A-Z]", "Uppercase letter"),
  ("[0-9]", "Digit"),
]

result = next((msg for pattern, msg in options if re.match(pattern, keypress)),
              "Punctuation, whitespace, or other")
print result
