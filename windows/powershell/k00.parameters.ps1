#!/usr/bin/env pash
# create function (subroutine)
Function Celsius ($fahrenheit)
{
   $temperature = ($fahrenheit - 32.0) * 5 / 9  # make calculation
   $temperature = "{0:N1}" -f $temperature      # reformat floating number
   # output results
   Write-Host "The Celsius temperature is ${temperature} degrees."
}

$temperature = 73                               # set temp in fahrenheit
Celsius $temperature                            # call the function (subroutine)