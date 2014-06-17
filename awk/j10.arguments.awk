#!/bin/awk -f
BEGIN {
  # illustrative variables
  arg_count   = ARGC - 1;  # get real num of arguments
  start_count = 1;         # set index of desired starting element 
  end_count   = arg_count; # set index of desired ending element

  print "The arguments passed are:"

  # iterative loop used to enumerate arguments
  for (count = start_count; count <= end_count; count++) {
    arg = ARGV[count]                    # fetch arg from index in array
    printf "  item %d: %s\n", count, arg # display count and arg
  }
}
