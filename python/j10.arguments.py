#!/usr/bin/python
import sys

# utility variables
count = 1                 # initialize counter

print "The arugments passed are:"
# use collection loop to enumerate arguments
#   Note: Python includes scriptname into collection
for arg in sys.argv[1:]:
   # print count and argument using count index
   print " item %d: %s" % (count,arg)
   # increment counter
   count += 1
