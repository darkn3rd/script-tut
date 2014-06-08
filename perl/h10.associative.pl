#!/usr/bin/perl -w
use strict;
# initialize hash w/ key/value pairs
my %ages=(bob=>34, ed=>58, steve=>32, ralph=>23);
  
# append another set of key/value pairs into hash
%ages=(%ages, deb=>46, kate=>19);
  
# enumerate through hash and print key/value pairs 
print "The ages are: \n";
foreach my $name (keys %ages) {
    print " ages[$name]=$ages{$name}\n";
}
