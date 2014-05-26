#!/bin/sh
count=$#                         # initialize counter
 
echo "The arguments passed are (reverse order):"
while [ $count -ge 1 ]; do       # loops while count is 1 or higher
  eval param=\$$count            # store positional parameter
  echo " item $count: $param"    # output result
  count=$(( $count - 1 ))        # decrement counter
done