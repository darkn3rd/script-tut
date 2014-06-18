#!/bin/sh
# illustrative variables
arg_count=$#           # get number of arguments
end_count=1            # ending count
start_count=$arg_count # starting count
# utility variables
count=$start_count     # initialize counter
  
echo "The arugments passed are:"
#  iterative style loop with range to enumerate list
for count in $(seq $start_count $end_count); do
  eval arg=\$$count         # get arg from positional parameter
  echo " item $count: $arg" # output count and arg
done 