#!/bin/awk -f
BEGIN {
  # acquire num of args and script name
  arg_count   = ARGC - 1;  # get num of arguments

  print "The arguments passed are:"

  # iterative loop used to enumerate arguments
  for (count = 1; count <= arg_count; count++)
    printf "  item %d: %s\n", count, ARGV[count]
}
