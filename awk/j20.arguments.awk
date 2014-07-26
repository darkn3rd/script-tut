#!/bin/awk -f
BEGIN {
  # illustrative variables
  ARG_COUNT   = ARGC - 1;  # get num of arguments
  START_COUNT = ARG_COUNT; # set index of desired starting element 
  END_COUNT   = 1;         # set index of desired ending element

  print "The arguments passed are (reverse order):"
  # iterative loop to enumerate arguments
  for (count = START_COUNT; count >= END_COUNT; count--) {
    arg = ARGV[count]                     # fetch arg from index in array
    printf "  item %d: %s\n", count, arg  # display count and arg
  }
}
