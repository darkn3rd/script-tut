# create function (subroutine)
Function Celsius ($fahrenheit)
{
   $temperature = ($fahrenheit - 32.0) * 5 / 9 
   $temperature = "{0:N1}" -f $temperature
   Write-Host "The Celsius temperature is ${temperature} degrees."
}

$temperature = 73
# call the function (subroutine)
celsius $temperature 