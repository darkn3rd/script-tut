#!/usr/bin/python
import sys

print "The arugments passed are:"
for count in range(1,len(sys.argv)):            # range operator to iterate to max arguments
   print " item %d: %s" % (count,sys.argv[count]) # print count and 1st argument