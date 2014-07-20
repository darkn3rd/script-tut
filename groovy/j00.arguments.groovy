#!/usr/bin/env groovy
// illustrative variables
ARG_COUNT   = args.size()  // get num of real arguments
SCRIPT_NAME = getClass().protectionDomain.codeSource.location.path.split('/')[-1]  

// check for only 2 arguments
if (ARG_COUNT != 2) {
   // ouptut usage statement to standard error
   System.err.println("\nYou need to enter two numbers: \n\n")
   System.err.println("   Usage: $SCRIPT_NAME [num1] [num2]\n\n")
} else {
   // get sum of both arguments, convert strings to integers
   sum = args[0].toInteger() + args[1].toInteger()
   // println results of both arguments (string) and summation (integer)
   println "The sum of ${args[0]} and ${args[1]} is: $sum."
}