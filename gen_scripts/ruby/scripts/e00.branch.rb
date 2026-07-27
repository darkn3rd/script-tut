#!/usr/bin/env ruby
print "Would you like a toast? [Yes/No]: " # print prompt
$stdout.flush                              # flush unbuffered stream
response = gets.chomp                      # acquire string input (remove newline)

# branch on the string value using case/when
case response
when "Yes"
  response_str = "That's great!"
else
  response_str = "How about a muffin?"
end

puts response_str
