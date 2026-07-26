#!/usr/bin/env perl -w
# Switch.pm - a source-filter module providing Perl6-style switch/case -
#  isn't core anymore and needs installing yourself (see ../README.md's
#  "Perl Modules (CPAN)" section). It's shown here for how a genuine
#  switch/case reads in Perl; e40.branch.pl's hash dispatch is the
#  dependency-free technique actually recommended today.
use Switch;

my $menu = <<'END';
Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

Make your selection: 
END
chomp $menu; # strip the heredoc's own trailing newline - no linebreak
             #  before the answer is typed
print $menu;
my $selection = <>; chomp $selection;

switch ($selection) {
    case 1 { print "You selected a Coffee\n" }
    case 2 { print "You selected an Espresso\n" }
    case 3 { print "You selected a Latte\n" }
    case 4 { print "You selected a Machiato\n" }
    case 5 { print "You selected a Capucino\n" }
    case 6 { print "You selected a Mocha\n" }
    case 7 { print "You selected a Tea\n" }
    else   { print "You have not entered a valid selection\n" }
}
