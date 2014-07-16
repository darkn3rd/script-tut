#!/usr/bin/python
import sys

# illustrative variables
ARG_COUNT   = len(sys.argv) - 1 # get num of real arguments
SCRIPT_NAME = sys.argv[0]       # get name of script

# check for only 2 arguments
if ARG_COUNT != 2:
   # ouptut usage statement to standard error
   sys.stderr.write("\nYou need to enter two numbers: \n\n")
   sys.stderr.write("   Usage: %s [num1] [num2]\n\n" % SCRIPT_NAME)
else:
   # get sum of both arguments, convert strings to integers
   sum = int(sys.argv[1]) + int(sys.argv[2])  
   # print results of both arguments (string) and summation (integer)
   print "The sum of %s and %s is: %d." % (sys.argv[1], sys.argv[2], sum)