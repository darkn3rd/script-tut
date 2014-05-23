#!/usr/bin/ruby
print "Enter your name: " # print prompt
STDOUT.flush              # flush buffer, so that prompt shows
name = gets               # acquire string input
print "Hello #{name}"     # output result using variable