#!/bin/awk -f
BEGIN {
  print "The arguments passed are (reverse order):"
  for (count = ARGC-1; count > 0; count--) {
    printf "  item %d: %s\n", count, ARGV[count]
     }
}
