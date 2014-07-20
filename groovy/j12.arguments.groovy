#!/usr/bin/env groovy
// illustrative variables 
LAST  = args.size() - 1 // index of last argument
FIRST = 0             // index of first argument

// utility variables
count = 1         // initialize counter

println "The arugments passed are:"
// use count style loop
while (count <= LAST) {
   arg = args[count-1]  // get arg using index
   // println count and argument using count index
   println " item $count: $arg"
   count += 1             // increment counter
}
