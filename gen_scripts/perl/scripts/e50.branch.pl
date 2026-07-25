#!/usr/bin/env perl -w
use v5.10.1;
print "Input a character: "; $keypress=getc(STDIN);

# # multiway branch using given...when construct
given ($keypress) {
  when (/[[:lower:]]/) { print "Lowercase letter\n"; }
  when (/[[:upper:]]/) { print "Uppercase letter\n"; }
  when (/[[:digit:]]/) { print "Digit\n" }
  default { print "Punctuation, whitespace, or other\n"; }
}
