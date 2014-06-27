#!/bin/ksh
# illustrative variables
arg_count=$# # get number of arguments
# utility variables
count=1      # initialize counter
 
print "The arguments passed are:"
#  iterative style loop to enumerate args
while (( $count <= $arg_count )); do # loops while count less than final arg
  arg=$1                             # get arg from first positional
  print " item $count: $arg"         # output count and arg
  count=$(( $count + 1 ))            # increment counter
  shift                              # shift positionals by one
done