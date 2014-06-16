#!/bin/awk -f
BEGIN {
  # acquire num of args and script name
  arg_count   = ARGC - 1;  # get num of arguments  

  print "The arguments passed are (reverse order):"
  # iterative loop to enumerate arguments
  for (count = arg_count; count > 0; count--) 
    printf "  item %d: %s\n", count, ARGV[count]
}
