#!/usr/bin/python
import sys

# illustrative variables
FIRST = 1                 # index of first argument
# utility variables
count = 1                 # initialize counter

print "The arugments passed are:"
# use collection loop to enumerate arguments
#   Note: Python includes scriptname into collection
for arg in sys.argv[FIRST:]:
   # print count and argument using count index
   print " item %d: %s" % (count,arg)
   # increment counter
   count += 1
