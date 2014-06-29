#!/bin/bash
# create subroutine
function celsius {
  # get argument and save it to friendly name
  fahrenheit=$1    
  # convert to new temperature using external bc tool
  temperature=$(echo "scale=20;($fahrenheit -32) * 5 / 9" | bc)
  # output results with format in one significant digit
  printf "The Celsius temperature is %.1f degrees.\n" $temperature
}

# call subroutine
temperature=73
celsius $temperature