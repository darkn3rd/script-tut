#!/usr/bin/env groovy
// illustrative variables 
ARG_COUNT = args.size() - 1 // get num of real arguments
FIRST     = 0                 // index of first argument
// utility variables
count     = ARG_COUNT         // initialize counter

println "The arugments passed are:"
// use count style loop
while (count >= FIRST) {
   arg = args[count]  // get arg using index
   // println count and argument using count index
   println " item ${count+1}: $arg"
   count -= 1             // decrement counter
}
