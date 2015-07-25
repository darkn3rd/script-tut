#!/usr/bin/env python
import sys  # system library for standard input and output

sys.stdout.write("Input a character: ")    # output prompt
keypress = sys.stdin.read(1)               # read one character

if keypress.islower():
  print "Lowercase letter"
elif keypress.isupper():
  print "Uppercase letter"
elif keypress.isdigit():
  print "Digit"
else:
  print "Punctuation, whitespace, or other"
