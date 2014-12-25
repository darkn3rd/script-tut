#!/usr/bin/env sh
# illustrative variables
arg_count=$#         # get number of arguments
# utility variables
count=1   # initialize counter
 
echo "The arguments passed are:"
#  iterative style loop to enumerate args
while [ $count -le $arg_count ]; do # loops while count less than final arg
  arg=$1                            # get arg from first positional
  echo " item $count: $arg"         # output count and arg
  count=$(( $count + 1 ))           # increment counter
  shift                             # shift positionals by one
done