#!/usr/bin/python
import sys

arg_count   = len(sys.argv) - 1 # get num of real arguments
script_name = sys.argv[0]       # get name of script

# check for only 2 arguments
if arg_count != 2:
 # print helpful instructions 
 print "You need to enter two numbers: %s num1 num2" % script_name 
else:
 # print sum pf two integer arguments
 print "The sum of %d and %d is: %d." % (int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[1]) + int(sys.argv[2]))
