#!/bin/awk -f

function celsius(fahrenheit)
{
  temperature = (fahrenheit - 32) * 5 / 9

  print "The Celsius temperature is " temperature " degrees."
}

BEGIN {
  temperature = 73
  celsius(temperature)
}
