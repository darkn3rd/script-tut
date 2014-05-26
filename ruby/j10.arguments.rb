#!/usr/bin/ruby

# use range operator to iterate to max arguments
for count in 1..ARGV.length
   puts " item #{count}: #{ARGV[0]}" # print count and 1st argument
   ARGV.shift                        # remove first element
end
