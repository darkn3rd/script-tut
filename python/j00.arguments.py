#!/usr/bin/python
import sys

arg_count   = len(sys.argv) - 1 # get num of real arguments
script_name = sys.argv[0]       # get name of script

# check for only 2 arguments
if arg_count != 2:
 # print helpful instructions 
 print "\nYou need to enter two numbers: \n"
 print "   Usage: %s [num1] [num2]\n" % script_name
else:
 # get sum of both arguments, force cast them to integer
 sum = int(sys.argv[1]) + int(sys.argv[2])  
 # print results of both arguments (string) and summation (integer)
 print "The sum of %s and %s is: %d." % (sys.argv[1], sys.argv[2], sum)