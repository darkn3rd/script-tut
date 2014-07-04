#!/usr/bin/python
import sys

# illustrative variables 
arg_count = len(sys.argv) - 1 # get num of real arguments
# utility variables
count     = arg_count         # initialize counter

print "The arugments passed are:"
# use count style loop
while count > 0:
   arg = sys.argv[count]  # get arg using index
   # print count and argument using count index
   print " item %d: %s" % (count,arg) 
   count -= 1             # decrement counter

