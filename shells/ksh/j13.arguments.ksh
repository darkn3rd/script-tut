#!/usr/bin/env ksh
# illustrative variables
min_count=0  # set mininum number of arguments
# utility variables
count=1      # initialize counter
 
print "The arugments passed are:"
#  conditional loop with shift to enumerate args
while (( $# > $min_count )); do # fetch updated number of arguments
  arg=$1                        # fetch arg from first positional parameter
  print " item $count: $arg"    # output count and arg
  count=$(( $count + 1 ))       # increment counter
  shift                         # shift positions down, so $2 becomes $1
done