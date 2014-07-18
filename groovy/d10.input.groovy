#!/usr/bin/env groovy
import sys  # system library for standard input and output
 
sys.stdout.write("Input a character: ")    # output prompt w/o newline
character = sys.stdin.read(1)              # read one character

# output results of character captured 
print "You entered: >>|%c|<<." % character
