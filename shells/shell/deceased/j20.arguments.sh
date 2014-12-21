#!/bin/sh
# illustrative variables
arg_count=$#     # get number of arguments
min_count=0      # set mininum number of arguments
# utility variables
count=$arg_count # initialize counter
 
echo "The arguments passed are (reverse order):"
#  iterative style loop to enumerate args
while [ $count -gt $min_count ]; do # loops while count is 1 or higher
  eval arg=\$$count                 # get arg from positional parameter
  echo " item $count: $arg"         # output count and arg
  count=$(( $count - 1 ))           # decrement counter
done