#!/bin/awk -f
BEGIN {
 width  = 5
 len    = 6
 area   = width * len
 print "The area of a square (width=" width ", length=" len ") is " area
 
 true   = 1
 false  = 0
 result = true && false || true
 print "The statement (true AND false OR true) is " result
}
