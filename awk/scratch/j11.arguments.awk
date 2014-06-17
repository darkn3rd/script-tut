#!/bin/awk -f
BEGIN {
  # illustrative variables
  script_name = ARGV[0];   # get script name
  # utility variables
  count       = 1;

  print "The arguments passed are:"

  # pseudo collection loop that enumerates keys
  for (idx in ARGV) {
    # fetch arg using count, as idx is out of order
    arg = ARGV[idx]
#    if (arg == script_name) { break; }  # skip if not real arg

    printf "  item %d: %s %s\n", count, idx, arg # output count and arg 
    count++
  }
}
