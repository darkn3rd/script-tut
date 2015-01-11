#!/usr/bin/env groovy
// illustrative variables
ARG_COUNT = args.size() // get number of arguments
// utility variables
count     = ARG_COUNT   // initialize counter

println "The arugments passed are:"
// use collection loop on a reversed list
for (arg in args.reverse()) {   //   collection loop produces arg
   // output count and argument using count
   println " item $count: $arg"
   // decrement counter
   count--
}