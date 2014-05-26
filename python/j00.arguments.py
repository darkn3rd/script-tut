#!/usr/bin/python
import sys

# check for only 2 arguments
if len(sys.argv) != 3:
 # print helpful instructions 
 print "You need to enter two numbers: %s num1 num2" % sys.argv[0]
else:
 # print sum pf two integer arguments
 print "The sum of %d and %d is: %d." % (int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[1]) + int(sys.argv[2]))
