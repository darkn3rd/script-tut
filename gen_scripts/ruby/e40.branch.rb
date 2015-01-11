#!/usr/bin/env ruby
print "Input a number: "   # print prompt
$stdout.flush              # flush unbuffered stream
number = gets.chomp.to_i   # acquire number (remove newline, convert to int)
 
if number > 0
  puts "Number is greater than 0"
elsif number < 0
  puts "Number is less than 0"
else
  puts "Number is 0"
end