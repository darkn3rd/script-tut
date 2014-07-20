#!/usr/bin/env groovy
import sys

// illustrative variables 
LAST  = args.size() // index of last argument
FIRST = 1             // index of first argument

// utility variables
count = FIRST         // initialize counter

println "The arugments passed are:"
// use count style loop
while (count < LAST) {
   arg = args[count]  // get arg using index
   // println count and argument using count index
   println " item %d: %s" % (count,arg) 
   count += 1             // increment counter
}
