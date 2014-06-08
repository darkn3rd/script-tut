#!/usr/bin/perl -w
my @nicknames=qw(bob ed steve ralph joe deb kate);
print "The names are: \n";
for (my $count=0; $count < scalar(@nicknames); $count++) {
  print " nicknames[$count]=$nicknames[$count]\n"
} 
