#!/usr/bin/python
import sys

# illustrative variables 
first     = 1             # index of first argument
last      = len(sys.argv) # index of last argument

print "The arugments passed are:"
# use iterative loop to enumerate arguments
for count in range(first,last):     # range operator gen sequence of numbers
   arg = sys.argv[count]            # get arg using index
   # print count and argument using count index
   print " item %d: %s" % (count,arg) 
