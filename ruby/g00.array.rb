#!/usr/bin/ruby
# create empty array
nicknames = Array.new
# insert elements by index
nicknames[0] = "bob"
nicknames[1] = "ed"
nicknames[2] = "steve"
nicknames[3] = "ralph"
nicknames[4] = "joe"
nicknames[5] = "deb"
nicknames[6] = "kate"
 
# print length
puts "The total nicknames are: #{nicknames.length}"
# enumerate full list
puts "The nicknames are: #{nicknames.join(" ")}"