#!/usr/bin/env ruby
# create empty hash
ages = Hash.new
# insert one element at a time
ages["bob"]   = 34
ages["ed"]    = 58
ages["steve"] = 32
ages["ralph"] = 23
ages["deb"]   = 46
ages["kate"]  = 19
 
# enumerate and print keys
puts "Keys (names):  #{ages.keys.join(" ")}"
# enumerate and print values
puts "Values (ages): #{ages.values.join(" ")}"