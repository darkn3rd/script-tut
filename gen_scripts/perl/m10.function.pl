#!/usr/bin/env perl -w
# create function that returns a string scalar
sub capitalize {
  return uc($_[0]);             # return capitalized string
}

# output string before calling function
my $string = "ibm";
print "The current string is: \"$string\".\n";
# call the function
my $result = capitalize($string); # pass string
# output results with resulting string
print "The capitalized string is: \"$result\".\n";
