#!/usr/bin/env perl -w
my @nicknames;          # declare list for good form

# insert one by one into list
$nicknames[0]="bob";
$nicknames[1]="ed";
$nicknames[2]="steve";
$nicknames[3]="ralph";
$nicknames[4]="joe";
$nicknames[5]="deb";
$nicknames[6]="kate";

# output number of elements and enumerated list
print "The number of nicknames is ", scalar(@nicknames),"\n";
print "The nicknames are: @nicknames\n";
