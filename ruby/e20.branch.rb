#!/usr/bin/ruby
print "Input a character: " # prompt
STDOUT.flush                # flush unbuffered stream
keypress = STDIN.getc       # acquire single character
 
# test if keypress matches pattern
if keypress =~ /[a-z]/
  puts "Lowercase letter"
elsif keypress =~ /[A-Z]/
  puts "Uppercase letter"
elsif keypress =~ /[0-9]/
  puts "Digit"
else
  puts "Punctuation, whitespace, or other"
end