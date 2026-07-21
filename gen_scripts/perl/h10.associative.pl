#!/usr/bin/env perl -w
use strict;
# declare and initialize hash some some elements
my %ages=(bob=>34, ed=>58, steve=>32, ralph=>23);

# append another set of key/value pairs into hash
%ages=(%ages, deb=>46, kate=>19);

# use collection loop with list of keys
print "The ages are: \n";
foreach my $name (keys %ages) {
    print " ages[$name]=$ages{$name}\n";
}
