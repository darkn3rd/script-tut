#!/usr/bin/perl
# create function that returns a string scalar
sub capitalize {
  return uc($_[0]);             # return capitlized string
}

# call the function
my $result = capitalize("ibm"); # pass string 
# output results with resulting string
print "The result of capitalization is: $result.\n";