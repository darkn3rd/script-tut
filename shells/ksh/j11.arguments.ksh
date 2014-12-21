#!/bin/ksh
# illustrative variables
arg_count=$#         # get number of arguments
  
print "The arugments passed are:"
#  iterative style loop with range to enumerate list
for count in {1..$arg_count}; do
  arg=$1                     # get arg from first positional
  print " item $count: $arg" # output count and arg
  shift                      # shift positionals by one
done