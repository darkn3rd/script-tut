#!/usr/bin/env groovy
// utility variables
count = 1                 // initialize counter

println "The arugments passed are:"
// use collection loop to enumerate arguments
//   Note: Python includes scriptname into collection
for (arg in args) {
   // println count and argument using count index
   println " item $count: $arg"
   // increment counter
   count += 1
}