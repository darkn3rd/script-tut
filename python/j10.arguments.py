#!/usr/bin/python
import sys

# illustrative variables 
script_name = sys.argv[0] # get name of script
# utility variables
count = 1                 # initialize counter

print "The arugments passed are:"
# use collection loop to enumerate arguments
#   Note: Python includes scriptname into collection
for arg in sys.argv:
   # avoid non-arguments
   if arg == script_name:
       continue
   # print count and argument using count index
   print " item %d: %s" % (count,arg)
   # increment counter
   count += 1
