#!/usr/bin/python
import sys

# illustrative variables
arg_count   = len(sys.argv) - 1 # get num of real arguments
script_name = sys.argv[0]       # get name of script

# subroutine to output usage message to stderr
def usage_message ():
   sys.stderr.write("\nYou need to enter two or more numbers: \n\n")
   sys.stderr.write("   Usage: %s [num1] [num2] [num3]...\n\n" % script_name)

# subroutine to sum numbers from array
def addNums (numbers):
   sum = 0                      # initialize starting sum value
   for num in numbers:          # collection loop toprocess numbers
     sum += int(num)            # sum up nums
   print "The summation is: %d" % sum # output results

# check for only 2 arguments
if arg_count < 1:
   # ouptut usage statement to standard error
   usage_message()
else:
   # call addNums to process arguments
   addNums(sys.argv[1:])