#!/usr/bin/perl -w
# declare and initilize list on one line
my @nicknames=qw(bob ed steve ralph joe deb kate);
# output the results of list
print "The names are: \n";
# use collection loop to get items in list
foreach my $name (@nicknames) {
 print " $name\n";
}
