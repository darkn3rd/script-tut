#!/bin/sh
# testbox: title="eval indirect indexing, until loop counting down"
# illustrative variables
arg_count=$#     # get number of arguments
min_count=0      # set mininum number of arguments
# utiltiy variables
count=$arg_count # initialize counter

echo "The arguments passed are (reverse order):"
#  iterative style loop to enumerate args
until [ $count -eq $min_count ]; do # loops until count drecrements to 0
  eval arg=\${$count}               # get arg from positional parameter - braced so two-digit
  echo " item $count: $arg"         # output count and arg
  count=$(( $count - 1 ))           # decrement counter
done
