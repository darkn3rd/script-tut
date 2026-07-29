#!/usr/bin/env groovy

// create subroutine
def celsius (fahrenheit) {
   // convert to float and calculate celsius
   temperature = (fahrenheit - 32) * 5 / 9

   // output results with 1 degree of significance
   printf "The Celsius temperature is %.1f degrees.\n", temperature
}

temperature = 73     // set initial temperature in degrees fahrenheit

// call the subroutine
celsius(temperature) // pass one int parameter
