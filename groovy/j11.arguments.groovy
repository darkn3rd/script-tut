#!/usr/bin/env groovy
import sys
// illustrative variables 
ARG_COUNT = args.size() - 1 // get num of real arguments
FIRST     = 1                 // index of first argument

println "The arugments passed are:"
// use collection loop with range to enumerate arguments
//   Note: range ending must be one greater than desired range
for (count in range(FIRST,ARG_COUNT+1)) { // range to gen sequence of numbers
   arg = args[count]               // get arg using index
   // println count and argument using count index
   println " item %d: %s" % (count,arg) 
}