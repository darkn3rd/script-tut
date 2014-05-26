#!/bin/sh
count=$#                         # initialize counter
 
echo "The arguments passed are (reverse order):"
until [ $count -eq 0 ]; do       # loops until count drecrements to 0
  eval param=\$$count            # store positional parameter
  echo " item $count: $param"    # output result
  count=$(( $count - 1 ))        # decrement counter
done