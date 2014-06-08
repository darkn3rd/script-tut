#!/usr/bin/perl -w
use v5.14;
  
print "Input a character: "; my $keypress=getc(STDIN);
  
for ($keypress) {
  print "Lowercase letter\n" when /[[:lower:]]/;
  print "Uppercase letter\n" when /[[:upper:]]/;
  print "Digit\n" when /[[:digit:]]/;
  default { print "Punctuation, whitespace, or other\n"; }
}
