#!/usr/bin/ruby

# illustrative variables
arg_count   = ARGV.length # get num of arguments (fetched once)
first       = 0           # set index of first element
start_count = 1           # set starting number to display to user
end_count   = arg_count   # set ending number to display to user

puts "The arugments passed are:"
# iterative loop with shift
for count in start_count..end_count      # range operator to iterate to max arguments
   puts " item #{count}: #{ARGV[first]}" # print count and 1st argument
   ARGV.shift                            # remove first element
end
