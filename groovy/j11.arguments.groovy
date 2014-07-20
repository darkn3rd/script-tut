#!/usr/bin/env groovy
// illustrative variables 
ARG_COUNT = args.size()   // get num of real arguments
FIRST     = 0             // index of first argument
LAST      = ARG_COUNT - 1 // index of last argument

println "The arugments passed are:"
// use collection loop with range to enumerate arguments
for (count in FIRST..LAST) {    // range to gen sequence of numbers
   arg = args[count]            // get arg using index
   // output count and argument using count index
   println " item ${count+1}: $arg"
}