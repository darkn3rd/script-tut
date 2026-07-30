#!/usr/bin/env tclsh
# closing brace stays on the same line as the prompt text (rather than
#  its own line) so the string has no trailing newline before the
#  answer is typed
set menu {Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

Make your selection: }
puts -nonewline $menu
flush stdout
gets stdin selection

switch $selection {
  1 { puts "You selected a Coffee" }
  2 { puts "You selected an Espresso" }
  3 { puts "You selected a Latte" }
  4 { puts "You selected a Machiato" }
  5 { puts "You selected a Capucino" }
  6 { puts "You selected a Mocha" }
  7 { puts "You selected a Tea" }
  default { puts "You have not entered a valid selection" }
}
