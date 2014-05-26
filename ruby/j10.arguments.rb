#!/usr/bin/ruby

puts "The arugments passed are:"
for count in 1..ARGV.length          # range operator to iterate to max arguments
   puts " item #{count}: #{ARGV[0]}" # print count and 1st argument
   ARGV.shift                        # remove first element
end
