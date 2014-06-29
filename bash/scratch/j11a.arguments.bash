#!/bin/bash
# illustrative variables
arg_count=$#         # get number of arguments
 
declare -a sequence=\($(eval echo {1..$arg_count})\)

echo "The arugments passed are:"
#  iterative style loop with range to enumerate list
for count in ${sequence[@]}; do
  arg=$1                    # get arg from first positional
  echo " item $count: $arg" # output count and arg
  shift                     # shift positionals by one
done