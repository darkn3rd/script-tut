#!/usr/bin/env ruby
# .chomp strips the heredoc's own trailing newline - no linebreak before
#  the answer is typed
menu = <<~END.chomp
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
print menu
$stdout.flush
selection = gets.chomp.to_i

if selection == 1
  puts "You selected a Coffee"
elsif selection == 2
  puts "You selected an Espresso"
elsif selection == 3
  puts "You selected a Latte"
elsif selection == 4
  puts "You selected a Machiato"
elsif selection == 5
  puts "You selected a Capucino"
elsif selection == 6
  puts "You selected a Mocha"
elsif selection == 7
  puts "You selected a Tea"
else
  puts "You have not entered a valid selection"
end
