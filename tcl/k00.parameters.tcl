#!/usr/bin/tclsh

# create subroutine
proc celsius {fahrenheit} {
  # convert to new temperature
  set temperature [expr ($fahrenheit - 32) * 5.0 / 9]
  
  # output results with format in one significant digit
  puts "The Celsius temperature is [format "%.1f" $temperature] degrees." 
}

# call subroutine
set temperature 73
celsius $temperature
