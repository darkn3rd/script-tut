#!/usr/bin/env perl -w
# conditional loop with do...while construction
do {
  print "Enter your name (quit to Exit): ";
  chomp($answer = <>);
  print "Hello $answer!\n" if ($answer ne "quit");
} while ($answer ne "quit")
