#!/usr/bin/ruby
print "Input a character: " # prompt
STDOUT.flush                #  flush unbuffered stream
keypress = STDIN.getc       # acquire single character
 
# test if keypress matches pattern
result = case keypress
  when /[a-z]/ then "Lowercase letter"
  when /[A-Z]/ then "Uppercase letter"
  when /[0-9]/ then "Digit"
  else "Punctuation, whitespace, or other"
end
 
puts result