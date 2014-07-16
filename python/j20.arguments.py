#!/usr/bin/python
import sys

# illustrative variables 
ARG_COUNT = len(sys.argv) - 1 # get num of real arguments
FIRST     = 1                 # index of first argument
# utility variables
count     = ARG_COUNT         # initialize counter

print "The arugments passed are:"
# use count style loop
while count >= FIRST:
   arg = sys.argv[count]  # get arg using index
   # print count and argument using count index
   print " item %d: %s" % (count,arg) 
   count -= 1             # decrement counter

