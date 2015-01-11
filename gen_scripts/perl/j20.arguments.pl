#!/usr/bin/env perl -w
# illustrative variables
my $last  = $#ARGV; # get index of last element
my $first = 0;      # set index of first element

print "The arguments passed are (reverse order):\n";
# iterative loop to enumerate args
#   Notes:
#    - $count     is index into $ARGV list
#    - $count + 1 is count that is displayed to user
for ( my $count = $last; $count >= $first ; $count-- ) {
  my $arg = $ARGV[$count];  # get arg using index
  # output count and argument using count index
  printf "  item %d: %s\n", $count+1, $arg;
}
