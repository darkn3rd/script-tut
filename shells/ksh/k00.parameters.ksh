#!/usr/bin/env ksh
# create subroutine
function celsius {
  # coerce temperature to float, e.g. 0.0
  typeset -F fahrenheit=$1    
  # convert to new temperature
  temperature=$(( ($fahrenheit - 32) * 5 / 9 ))
  
  # output results with format in one significant digit
  printf "The Celsius temperature is %.1f degrees.\n" $temperature
}

# call subroutine
temperature=73
celsius $temperature