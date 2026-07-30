#!/usr/bin/env -S perl -w
print "Input a character: ";   # print prompt w/o newline
read(STDIN, my $character, 1); # read exactly one character (fine on piped/non-tty stdin, no raw-mode needed)

# output results of character captured
print "You entered: >>|$character|<<.\n";
