#!/usr/bin/env sh
# illustrative variables
min_count=0  # set mininum number of arguments
# utility variables
count=1      # initialize counter
 
echo "The arugments passed are:"
#  conditional loop with shift to enumerate args
while [ $# -gt $min_count ]; do # fetch updated number of arguments
  arg=$1                        # fetch arg from first positional parameter
  echo " item $count: $arg"     # output count and arg
  count=$(( $count + 1 ))       # increment counter
  shift                         # shift positions down, so $2 becomes $1
done
