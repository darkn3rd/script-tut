#!/usr/bin/env sh
# utility variables
count=1      # initialize counter
 
echo "The arugments passed are:"
#  collection loop to enumerate lists
for arg in "$@"; do
  echo " item $count: $arg" # output count and arg
  count=$(( $count + 1 ))   # increment counter
done 
