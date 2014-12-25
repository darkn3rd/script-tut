#!/usr/bin/env ruby
# create populated array
nicknames = %w(bob ed steve ralph joe deb kate)
# iterate through array by index
puts "The names are: "
nicknames.length.times { |count| puts " nicknames[#{count}]=#{nicknames[count]}"}