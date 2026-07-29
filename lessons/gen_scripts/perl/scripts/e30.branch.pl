#!/usr/bin/env perl -w
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

if ( $selection == 1 ) {
    print "You selected a Coffee\n";
} elsif ( $selection == 2 ) {
    print "You selected an Espresso\n";
} elsif ( $selection == 3 ) {
    print "You selected a Latte\n";
} elsif ( $selection == 4 ) {
    print "You selected a Machiato\n";
} elsif ( $selection == 5 ) {
    print "You selected a Capucino\n";
} elsif ( $selection == 6 ) {
    print "You selected a Mocha\n";
} elsif ( $selection == 7 ) {
    print "You selected a Tea\n";
} else {
    print "You have not entered a valid selection\n";
}
