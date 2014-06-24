#!/bin/sh
count=10   # initialize counter

# iterative style loop emulated 
#   using conditional loop with counters
while [ $count -gt 0 ]; do
   echo "Count is $count"
   count=$(( $count - 1 ))
done