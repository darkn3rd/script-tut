#!/usr/bin/env python
import sys  # system library for standard input and output
import re   # regular expresion library
 
sys.stdout.write("Input a character: ")    # output prompt
keypress = sys.stdin.read(1)               # read one character

if re.match("[a-z]", keypress):
  print "Lowercase letter"
elif re.match("[A-Z]", keypress):
  print "Uppercase letter"
elif re.match("[0-9]", keypress):
  print "Digit"
else:
  print "Punctuation, whitespace, or other"