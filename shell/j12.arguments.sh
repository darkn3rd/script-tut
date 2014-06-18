#!/bin/sh
# illustrative variables
arg_count=$#         # get number of arguments
end_count=$arg_count # ending count
start_count=1        # starting count
# utility variables
count=$start_count   # initialize counter
 
echo "The arguments passed are:"
#  iterative style loop to enumerate args
while [ $start_count -le $end_count ]; do # loops while count less than final arg
  eval arg=\$$count                       # get arg from positional parameter
  echo " item $count: $arg"               # output count and arg
  count=$(( $count + 1 ))                 # increment counter
done