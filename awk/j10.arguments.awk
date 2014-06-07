#!/bin/awk -f
BEGIN {
  print "The arugments passed are:"
  for (count = 1; count < ARGC; count++) {
    printf "  item %d: %s\n", count, ARGV[count]
     }
}
