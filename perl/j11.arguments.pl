#!/usr/bin/perl
my $last      = $#ARGV;     # get index of last element
my $first     = 0;          # set index of first element 

print "The arguments passed are:\n";
# iterative loop to enumerate args
for ( my $count = $first; $count <= $last ; $count++ ) {
  printf "  item %d: %s\n", $count+1, $ARGV[$count];
}