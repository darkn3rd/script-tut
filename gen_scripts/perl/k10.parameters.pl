#!/usr/bin/env perl -w
# create subroutine with variable parameters
sub addNums {
   my @numbers = @_;   # retreive variable parameters
   my $sum = 0;        # initalize to 0

   # add all the $num in @numbers list
   foreach $num (@numbers) { $sum += $num }

   # output results
   print "The summation is: $sum\n";
}

# call the subroutine (function)
addNums 5, 2, 4, 3, 6; # pass variable number of numbers
