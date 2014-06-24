#!/usr/bin/perl -w
# spin loop construction with last to exiting
while (1) {
  print "Enter your name (quit to exit): ";
  chomp($answer = <>);
  last if $answer eq "quit";
  print "Hello $answer\n";
}
