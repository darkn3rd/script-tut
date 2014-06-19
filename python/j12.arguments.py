#!/usr/bin/python
import sys

# illustrative variables 
last  = len(sys.argv) # index of last argument
# utility variables
count = 1             # initialize counter

print "The arugments passed are:"

# use iterative loop
while count < last:
   arg = sys.argv[count]  # get arg using index
   # print count and argument using count index
   print " item %d: %s" % (count,arg) 
   count += 1             # increment counter

