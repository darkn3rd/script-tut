#!/usr/bin/python
import sys
# illustrative variables
ARG_COUNT   = len(sys.argv) - 1 # get num of real arguments
# utility variables
count = ARG_COUNT               # initialize counter

print "The arugments passed are:"
# use collection loop to enumerate arguments
for arg in reversed(sys.argv[1:]):
   # print count and argument using count index
   print " item %d: %s" % (count,arg)
   # decrement counter
   count -= 1
