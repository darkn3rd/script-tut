#!/usr/bin/env perl
# get input from user
print "Would you like a toast? [Yes/No]: ";
my $response=<>;               # acquire string input including newline
chomp $response;               # strip newline

# set response string using one line (ternary statement)
#   Test response to a string
$response_str = ($response eq "Yes") ? "That's great!" : "How about a muffin?";

# output the response string
print "$response_str\n";
