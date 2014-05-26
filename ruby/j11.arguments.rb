#!/usr/bin/ruby
count = 0                             # initialize counter

puts "The arugments passed are:"
while ARGV.length >= 1 do
 puts " item #{count+=1}: #{ARGV[0]}" # output result of first argument
 ARGV.shift                           # remove first element
end
