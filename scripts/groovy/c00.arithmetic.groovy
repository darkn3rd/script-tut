#!/usr/bin/env groovy
// basic integer arithmatic
width  = 5              // defaults to java.lang.Integer
length = 6              // defaults to java.lang.Integer
area   = width * length // defaults to java.lang.Integer

// output results of math
printf "The area of a square (width=%d, length=%d) is %d\n", width, length, area
