#!/usr/bin/env python

# create subroutine
def celsius (fahrenheit):
   # convert to float and calculate celsius
   temperature = (fahrenheit - 32.0) * 5 / 9

   # output results with 1 degree of significance
   print "The Celsius temperature is %.1f degrees." % temperature

temperature = 73     # set initial temperature in degrees fahrenheit

# call the subroutine
celsius(temperature) # pass one int parameter
