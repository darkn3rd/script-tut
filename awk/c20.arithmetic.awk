#!/bin/awk -f
BEGIN {
 # declare scalar variables
 PI     = 3.14159265359
 radius = 3

 # calculate area
 area   = PI * radius^2

 # output results
 print "The area of a circle with a radius of 3 is: " area
}
