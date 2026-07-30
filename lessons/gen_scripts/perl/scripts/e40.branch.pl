#!/usr/bin/env -S perl -w
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

# Perl has no built-in switch statement - Switch.pm is a deprecated,
#  no-longer-core source-filter module (see e41.branch.pl), and
#  given/when was experimental for its entire ~14-year life before
#  being deprecated in 5.38. A hash keyed by value is the idiomatic,
#  dependency-free stand-in for a multiway branch.
my %options = (
    1 => "You selected a Coffee",
    2 => "You selected an Espresso",
    3 => "You selected a Latte",
    4 => "You selected a Machiato",
    5 => "You selected a Capucino",
    6 => "You selected a Mocha",
    7 => "You selected a Tea",
);

print(($options{$selection} // "You have not entered a valid selection") . "\n");
