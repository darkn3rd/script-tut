#!/usr/bin/env groovy
// illustrative variables 
ARG_COUNT = args.size()   // get num of real arguments
FIRST     = 0             // index of first argument in list
MIN_COUNT = FIRST

println "The arugments passed are:"
// loop until there are no more items in list
for (count = 1; args.size() > MIN_COUNT; count++) {    
   arg = args[FIRST]   // get first argument of list
   // output count and argument using count index
   println " item ${count}: $arg"
   args = args.drop(1) // remove first element of list
}