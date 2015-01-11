#!/usr/bin/env ruby
print "Enter your name: "   # print prompt
STDOUT.flush                # flush buffer, so that prompt shows
name = gets                 # acquire string input
puts "Hello #{name.chomp}!" # output result using variable
