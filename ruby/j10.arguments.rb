#!/usr/bin/ruby
arg_count = ARGV.length   # get num of arguments
first     = 0             # set index of first element
last      = arg_count - 1 # set index of last element

puts "The arguments passed are (reverse order):"
# iterative loop using array index
for index in first.upto(last)             # decrement from # of args to 0 
  puts " item #{index+1}: #{ARGV[index]}" # count & correponding ARGV element
end
