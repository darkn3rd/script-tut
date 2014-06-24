#!/usr/bin/perl -w
#until construction
do {
  print "Enter your name (quit to exit): ";
  chomp($answer = <>);
  print "Hello $answer\n" if ($answer ne "quit");
} while ($answer ne "quit")
