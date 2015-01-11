#!/usr/bin/env ruby
# initialize array with key/value pairs
ages = {"bob"=> 34, "ed"=> 58, "steve"=> 32, "ralph"=> 23}
# append another set of key/value pairs into array
ages = ages.merge("deb"=> 46, "kate"=> 19)
# iterate through hash by keys, print key/value pairs
puts "The ages are: "
ages.keys.each { |name| puts " ages[#{name}]=#{ages[name]}"}