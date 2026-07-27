#!/usr/bin/env ruby
print "Would you like a toast? [Yes/No]: " # print prompt
$stdout.flush                              # flush unbuffered stream
response = gets.chomp                      # acquire string input (remove newline)

# set response string using ternary (single-line) conditional
response_str = response == "Yes" ? "That's great!" : "How about a muffin?"

puts response_str
