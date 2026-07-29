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

case selection
when 1
  puts "You selected a Coffee"
when 2
  puts "You selected an Espresso"
when 3
  puts "You selected a Latte"
when 4
  puts "You selected a Machiato"
when 5
  puts "You selected a Capucino"
when 6
  puts "You selected a Mocha"
when 7
  puts "You selected a Tea"
else
  puts "You have not entered a valid selection"
end
