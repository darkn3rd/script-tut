#!/usr/bin/env ruby

# create method (subroutine)
def celsius (fahrenheit)
  temperature = (fahrenheit - 32.0) * 5 / 9 
  puts "The Celsius temperature is %.1f degrees." % temperature
end

temperature = 73
# call the method (subroutine)
celsius temperature 
