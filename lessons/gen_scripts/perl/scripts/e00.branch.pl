#!/usr/bin/env perl
# get input from user
print "Would you like a toast? [Yes/No]: ";
my $response=<>;               # acquire string input including newline
chomp $response;               # strip newline

# set response string using if/else construction
#   Test response to a string
if ($response eq "Yes") {
  $response_str = "That's great!\n";
} else {
  $response_str = "How about a muffin?\n";
}
# output the response string
print $response_str;
