#!/usr/bin/env perl -w
# conditional loop with while construction
my $answer="";
while ($answer ne "quit") {
  print "Enter your name (quit to Exit): ";
  chomp($answer = <>);
  print "Hello $answer!\n" if ($answer ne "quit");
}
