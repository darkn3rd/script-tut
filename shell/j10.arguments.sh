#!/bin/sh
count=1                         # initialize counter
 
echo "The arugments passed are:"
while [ $# -ge 1 ]; do
  echo " item $count: $1"       # output result
  count=$(( $count + 1 ))       # increment counter
  shift                         # shift positions down, so $2 becomes $1
done
