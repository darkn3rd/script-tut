#!/usr/bin/ruby

puts "The arguments passed are (reverse order):"
for count in ARGV.length.downto(1)         # decrement from # of args to 1
  puts " item #{count}: #{ARGV[count-1]}"  # count & correponding ARGV element
end  