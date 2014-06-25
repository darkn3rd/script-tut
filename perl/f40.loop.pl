#!/usr/bin/perl -w
# spin loop construction with last to exiting
while (1) {
  print "Enter your name (quit to exit): "; # prompt user
  chomp($answer = <>);                      # git input and trim newline
  next if $answer =~ /^[\t\s]*$/;           # skip loop if not answer entered
  last if $answer eq "quit";                # exit loop if user wants to quit
  print "Hello $answer!\n";                 # output results as not exiting
}
