#!/bin/sh
# illustrative variables
arg_count=$#         # get number of arguments
  
echo "The arugments passed are:"
#  iterative style loop with range to enumerate list
for count in $(seq 1 $arg_count); do
  arg=$1                    # get arg from first positional
  echo " item $count: $arg" # output count and arg
  shift                     # shift positionals by one
done