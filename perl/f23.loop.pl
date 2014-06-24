#!/usr/bin/perl -w
#until construction
my $answer="";
while ($answer ne "quit") {
  print "Enter your name (quit to exit): ";
  chomp($answer = <>);
  print "Hello $answer\n" if ($answer ne "quit");
}
