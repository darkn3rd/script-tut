#!/usr/bin/env perl -w
# conditional loop with do...until construction
do {
  print "Enter your name (quit to Exit): ";
  chomp($answer = <>);
  print "Hello $answer!\n" if ($answer ne "quit");
} until ($answer eq "quit")
