#!/usr/bin/env ruby
# illustrative variables
first     = 0  # set index of first element
min_count = 0  # set minimum number of elements required
# utility variables
count     = 0  # initialize counter

puts "The arguments passed are:"
# conditional loop to process elements using shift
while ARGV.length > min_count do          # fetches updated num of args
 puts " item #{count+=1}: #{ARGV[first]}" # output result of first argument
 ARGV.shift                               # remove first element
end
