#!/usr/bin/python
import sys

# illustrative variables 
arg_count = len(sys.argv) - 1 # get num of real arguments

print "The arugments passed are:"
# use collection loop with range to enumerate arguments
#   Note: range to generate indexes of argument positions
for count in range(arg_count,0,-1): # range to gen sequence of nums
   arg = sys.argv[count]                    # get arg using index
   # print count and argument using count index
   print " item %d: %s" % (count,arg) 
