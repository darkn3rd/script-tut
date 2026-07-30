#!/usr/bin/env -S perl -w
# conditional loop until construction
my $answer="";
until ($answer eq "quit") {
  print "Enter your name (quit to Exit): ";
  chomp($answer = <>);
  print "Hello $answer!\n" if ($answer ne "quit");
}
