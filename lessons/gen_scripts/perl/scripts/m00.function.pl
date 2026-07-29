#!/usr/bin/env perl -w
# create function that returns an integer
sub addNums {
   my @numbers = @_;   # retreive variable parameters
   my $sum = 0;        # initalize to 0

   # add all the $num in @numbers list
   foreach $num (@numbers) { $sum += $num }

   return $sum;        # return sum of numbers
}

my @parameters = (5, 2, 4, 3, 6);
print "The numbers to be added are " . join(", ", @parameters) . ".\n";
# call the function
my $result = addNums @parameters; # pass variable number of numbers
# output results with resulting integer
print "The result of their summation is: $result.\n";
