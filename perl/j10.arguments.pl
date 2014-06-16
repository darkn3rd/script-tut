#!/usr/bin/perl
my $count     = 1;  # initialize counter

print "The arguments passed are:\n";
# collection loop to enumerate args
foreach my $arg (@ARGV) {
  # output count, arg, and increment count
  printf "  item %d: %s\n", $count++, $arg;
}