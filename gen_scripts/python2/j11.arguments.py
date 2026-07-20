#!/usr/bin/env python
import sys
# illustrative variables 
ARG_COUNT = len(sys.argv) - 1 # get num of real arguments
FIRST     = 1                 # index of first argument

print "The arugments passed are:"
# use collection loop with range to enumerate arguments
#   Note: range ending must be one greater than desired range
for count in range(FIRST,ARG_COUNT+1): # range to gen sequence of numbers
   arg = sys.argv[count]               # get arg using index
   # print count and argument using count index
   print " item %d: %s" % (count,arg) 
