#!/bin/awk -f
BEGIN {
 # declare scalar variables
 width  = 5
 len    = 6

 # calculate area
 area   = width * len

 # output result
 print "The area of a square (width=" width ", length=" len ") is " area
}
