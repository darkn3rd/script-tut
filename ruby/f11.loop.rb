#!/usr/bin/ruby
# count style loop using range operator to generate
#   sequence of numbers that is fed to each iterator
(1..10).to_a.reverse.each do |count|
  puts "Count is #{count}"
end