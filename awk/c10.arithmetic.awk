#!/bin/awk -f
BEGIN {
 # illustrative variables
 true   = 1
 false  = 0

 # calculate the result
 result = true && false || true

 # output results
 print "The statement (true AND false OR true) is " result
}
