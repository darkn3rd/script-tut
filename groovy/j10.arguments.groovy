#!/usr/bin/env groovy
import sys

// illustrative variables
FIRST = 1                 // index of first argument
// utility variables
count = 1                 // initialize counter

println "The arugments passed are:"
// use collection loop to enumerate arguments
//   Note: Python includes scriptname into collection
for (arg in args[FIRST:]) {
   // println count and argument using count index
   println " item %d: %s" % (count,arg)
   // increment counter
   count += 1
}