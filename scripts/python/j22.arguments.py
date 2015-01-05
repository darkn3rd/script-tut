#!/usr/bin/env python
import sys
# illustrative variables
ARG_COUNT   = len(sys.argv) - 1 # get num of real arguments
FIRST       = 1                 # index of first argument
# utility variables
count       = ARG_COUNT         # initialize counter

print "The arugments passed are:"
# use collection loop on list slice
for arg in reversed(sys.argv[FIRST:]):
   # print count and argument using count index
   print " item %d: %s" % (count,arg)
   # decrement counter
   count -= 1
