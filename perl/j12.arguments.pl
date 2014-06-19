#!/usr/bin/perl
# illustrative variables
my $last  = $#ARGV; # get index of last element
my $first = 0;      # set index of first element 

print "The arguments passed are:\n";
# iterative loop to enumerate args
#   Notes:
#    - $count     is index into array
#    - $count + 1 is count that is displayed to user
for ( my $count = $first; $count <= $last ; $count++ ) {
  my $arg = $ARGV[$count];  # get arg using index
  # output count and argument using count index
  printf "  item %d: %s\n", $count+1, $arg;
}