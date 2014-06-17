#!/usr/bin/ruby

arg_count = ARGV.length # get num of arguments
first     = 0           # set index of first element

puts "The arugments passed are:"
for count in 1..arg_count                # range operator to iterate to max arguments
   puts " item #{count}: #{ARGV[first]}" # print count and 1st argument
   ARGV.shift                            # remove first element
end
