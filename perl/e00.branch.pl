#!/usr/bin/perl -w
print "Input a number: "; my $Number=<>; chomp $Number;
if ( $Number > 0 ) {
    print "Number is greater than 0\n";
} elsif ( $Number < 0 ) {
    print "Number is less than 0\n";
} else {
    print "Number is 0\n";
}
