#!/usr/bin/python
import sys

# illustrative variables 
first     = 1             # index of first argument
last      = len(sys.argv) # index of last argument

print "The arugments passed are:"
# use iterative loop to enumerate arguments
for count in reversed(range(first,last)): # range operator to gen sequence of nums
   arg = sys.argv[count]                  # get arg using index
   # print count and argument using count index
   print " item %d: %s" % (count,arg) 
