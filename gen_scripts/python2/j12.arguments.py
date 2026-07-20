#!/usr/bin/env python
import sys

# illustrative variables 
LAST  = len(sys.argv) # index of last argument
FIRST = 1             # index of first argument

# utility variables
count = FIRST         # initialize counter

print "The arugments passed are:"
# use count style loop
while count < LAST:
   arg = sys.argv[count]  # get arg using index
   # print count and argument using count index
   print " item %d: %s" % (count,arg) 
   count += 1             # increment counter

