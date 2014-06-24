#!/bin/sh
count=10   # initialize counter

# count style loop using while
while [ $count -gt 0 ]; do
   echo "Count is $count"
   count=$(( $count - 1 ))
done