#!/usr/bin/ruby
arg_count = ARGV.length # get num of arguments
first     = 0           # set index of first element
count     = 0           # initialize counter

puts "The arugments passed are:"
while ARGV.length >= 1 do
 puts " item #{count+=1}: #{ARGV[first]}" # output result of first argument
 ARGV.shift                               # remove first element
end
