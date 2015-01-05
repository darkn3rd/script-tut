#!/usr/bin/env groovy
// illustrative variables 
ARG_COUNT   = args.size()   // get num of real arguments
FIRST       = 0             // set index of first argument in list
START_COUNT = 1             // set starting counter to output to user
END_COUNT   = ARG_COUNT     // set ending counter to output to user

println "The arugments passed are:"
// loop arbitrary number of times based on original size of list
for (count in START_COUNT..END_COUNT) {   
   arg = args[FIRST]              // get first argument of list
   println " item ${count}: $arg" // output count and arg
   args = args.drop(1)            // remove first element of list
}