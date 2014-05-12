#!/usr/bin/python
import sys
import re
 
sys.stdout.write("Input a character: ")
keypress = sys.stdin.read(1)
 
if re.compile("[a-z]").match(keypress):
  print "Lowercase letter"
elif re.compile("[A-Z]").match(keypress):
  print "Uppercase letter"
elif re.compile("[0-9]").match(keypress):
  print "Digit"
else:
  print "Punctuation, whitespace, or other"