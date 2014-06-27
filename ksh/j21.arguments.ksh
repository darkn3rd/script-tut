#!/bin/ksh
# illustrative variables
arg_count=$#           # get number of arguments
# utility variables
output=""
  
print "The arugments passed are (reverse order):"
#  iterative style loop with range to enumerate list
for count in {1..$arg_count}; do
  arg=$1                    # get arg from first positional
  # build ouput string by prepending previous result
  output="  item $count: $arg\n$output" 
  shift                     # shift positionals by one
done

# output resulting compiled string
print -n "$output"