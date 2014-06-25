#!/usr/bin/perl -w
# conditional loop with do...while construction
do {
  print "Enter your name (quit to exit): ";
  chomp($answer = <>);
  print "Hello $answer!\n" if ($answer ne "quit");
} while ($answer ne "quit")
