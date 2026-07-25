#!/usr/bin/env perl -w
print "Enter your name: "; # print prompt
my $name=<>;               # acquire string input including newline
chomp $name;               # strip newline
print "Hello $name!\n";     # output result using variable
