#!/usr/bin/env perl -w
# utility variables
my $count     = 1;  # initialize counter

print "The arguments passed are:\n";
# collection loop to enumerate args
#   Notes:
#    - $count     is count that is displayed to user
foreach my $arg (@ARGV) {
  # output count, arg, and increment count
  printf "  item %d: %s\n", $count++, $arg;
}
