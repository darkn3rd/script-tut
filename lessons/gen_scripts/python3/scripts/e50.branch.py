#!/usr/bin/env python3
import sys  # system library for standard input and output
import re   # regular expresion library

sys.stdout.write("Input a character: ")    # output prompt
keypress = sys.stdin.read(1)               # read one character

# multiway branch using match/case (Python 3.10+) with guard clauses to
#  emulate pattern matching - see e60/e61.branch.py for the if/elif
#  equivalents using re.match()/str methods
match keypress:
  case c if re.match("[a-z]", c):
    print("Lowercase letter")
  case c if re.match("[A-Z]", c):
    print("Uppercase letter")
  case c if re.match("[0-9]", c):
    print("Digit")
  case _:
    print("Punctuation, whitespace, or other")
