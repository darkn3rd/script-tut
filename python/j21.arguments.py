#!/usr/bin/python
import sys

# illustrative variables 
ARG_COUNT = len(sys.argv) - 1 # get num of real arguments

print "The arugments passed are:"
# use collection loop with range to enumerate arguments
#   Note: range to generate indexes of argument positions
for count in range(ARG_COUNT,0,-1): # range to gen sequence of nums
   arg = sys.argv[count]                    # get arg using index
   # print count and argument using count index
   print " item %d: %s" % (count,arg) 
