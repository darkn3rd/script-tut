#!/usr/bin/ruby
# count style loop with times iterator
10.times.to_a.reverse.each do |count|
  # output result, some math used reverse number
  puts "Count is #{(count+1)}"  
end