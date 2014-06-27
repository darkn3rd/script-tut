#!/bin/ksh
# utility variables
count=1      # initialize counter
 
print "The arugments passed are:"
#  collection loop to enumerate lists
for arg in "$@"; do
  print " item $count: $arg" # output count and arg
  count=$(( $count + 1 ))   # increment counter
done 