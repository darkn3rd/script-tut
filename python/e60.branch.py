#!/usr/bin/python
import sys  # system library for standard input and output
import re   # regular expresion library
 
sys.stdout.write("Input a character: ")    # output prompt
keypress = sys.stdin.read(1)               # read one character
 
if re.compile("[a-z]").match(keypress):
  print "Lowercase letter"
elif re.compile("[A-Z]").match(keypress):
  print "Uppercase letter"
elif re.compile("[0-9]").match(keypress):
  print "Digit"
else:
  print "Punctuation, whitespace, or other"