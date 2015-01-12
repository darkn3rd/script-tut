#!/usr/bin/env perl -w
# illustrative variables
my ($true, $false) = (1,0);

# calculate boolean logic
my $result=$true && $false || $true;

# output results
print "The statement (true AND false OR true) is: $result.\n";
