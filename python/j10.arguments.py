#!/usr/bin/python
import sys

# illustrative variables 
first     = 1
last      = len(sys.argv) 

print "The arugments passed are:"
# use iterative loop to enumerate arguments
for count in range(first,last):     # range operator gen sequence of numbers
   # print count and argument using count index
   print " item %d: %s" % (count,sys.argv[count]) 
