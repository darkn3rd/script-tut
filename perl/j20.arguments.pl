#!/usr/bin/perl
# acquire num of args
$arg_count = $#ARGV + 1; # get num of arguments
$last      = $#ARGV;     # get index of last element
$first     = 0;          # set index of first element 

print "The arguments passed are (reverse order):\n";
# iterative loop to enumerate args
for ( my $count = $last; $count >= $first ; $count-- ) {
  printf "  item %d: %s\n", $count+1, $ARGV[$count];
}