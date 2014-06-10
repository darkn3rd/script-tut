#!/bin/awk -f

function celsius(fahrenheit)
{
  # convert to new temperature
  temperature = (fahrenheit - 32) * 5 / 9
  # output results
  printf "The Celsius temperature is %.1f degrees.\n", temperature
}

BEGIN {
  temperature = 73       # store original temperature
  celsius(temperature)   # call function to convert and output results
}
