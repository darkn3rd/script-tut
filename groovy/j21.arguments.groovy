#!/usr/bin/env groovy
// illustrative variables 
ARG_COUNT = args.size() // get num of real arguments
LAST      = ARG_COUNT - 1
FIRST     = 0

println "The arugments passed are:"
// use collection loop with range to enumerate arguments
//   Note: range to generate indexes of argument positions
for (count in LAST..FIRST) {   // range to gen sequence of nums
   arg = args[count]           // get arg using index
   // output count and argument using count index
   println " item ${count+1}: $arg" 
}