#!/bin/awk -f
BEGIN {
  print "The arugments passed are (reverse order):"
  for (count = ARGC; count > 0; count--) {
    printf "  item %d: %s\n", count, ARGV[count]
     }
}
