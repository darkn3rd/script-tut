#!/usr/bin/python
import sys  # system library for standard input and output
 
sys.stdout.write("Input a character: ")    # output prompt
character = sys.stdin.read(1)              # read one character

# output variable
print "You entered: >>|%c|<<." % character