#!/usr/bin/env perl -w
print "Input a character: "; $keypress=getc(STDIN);

if ($keypress =~ /[[:lower:]]/) {
    print "Lowercase letter\n";
} elsif ($keypress =~ /[[:upper:]]/) {
    print "Uppercase letter\n";
} elsif ($keypress =~ /[[:digit:]]/) {
    print "Digit\n";
} else {
    print "Punctuation, whitespace, or other\n";
}
