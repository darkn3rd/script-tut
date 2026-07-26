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

if {$selection == 1} {
  puts "You selected a Coffee"
} elseif {$selection == 2} {
  puts "You selected an Espresso"
} elseif {$selection == 3} {
  puts "You selected a Latte"
} elseif {$selection == 4} {
  puts "You selected a Machiato"
} elseif {$selection == 5} {
  puts "You selected a Capucino"
} elseif {$selection == 6} {
  puts "You selected a Mocha"
} elseif {$selection == 7} {
  puts "You selected a Tea"
} else {
  puts "You have not entered a valid selection"
}
