#!/usr/bin/env groovy
import sys
// illustrative variables
ARG_COUNT   = args.size() - 1 // get num of real arguments
FIRST       = 1                 // index of first argument
// utility variables
count       = ARG_COUNT         // initialize counter

println "The arugments passed are:"
// use collection loop on list slice
for (arg in reversed(args[FIRST:])) {
   // println count and argument using count index
   println " item %d: %s" % (count,arg)
   // decrement counter
   count -= 1
}