#!/usr/bin/env perl -w
use v5.14;

print "Input a character: "; my $keypress=getc(STDIN);

# multiway branch using for..when construct
for ($keypress) {
  print "Lowercase letter\n" when /[[:lower:]]/;
  print "Uppercase letter\n" when /[[:upper:]]/;
  print "Digit\n" when /[[:digit:]]/;
  default { print "Punctuation, whitespace, or other\n"; }
}
