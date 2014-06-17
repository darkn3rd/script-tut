#!/usr/bin/ruby
arg_count = ARGV.length   # get num of arguments
first     = 0             # set index of first element
last      = arg_count - 1 # set index of last element

puts "The arguments passed are (reverse order):"
for count in last.downto(first)           # decrement from # of args to 0 
  puts " item #{count+1}: #{ARGV[count]}" # count & correponding ARGV element
end  
