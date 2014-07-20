#!/usr/bin/env groovy
import sys

// illustrative variables 
ARG_COUNT = args.size() - 1 // get num of real arguments

println "The arugments passed are:"
// use collection loop with range to enumerate arguments
//   Note: range to generate indexes of argument positions
for (count in range(ARG_COUNT,0,-1)) { // range to gen sequence of nums
   arg = args[count]            // get arg using index
   // println count and argument using count index
   println " item %d: %s" % (count,arg) 
}