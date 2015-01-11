#!/usr/bin/env groovy
// illustrative variables
ARG_COUNT   = args.size() // get num of real arguments
SCRIPT_NAME = getClass().protectionDomain.codeSource.location.path.split('/')[-1]
EX_USAGE    = 64;         // status for command line usage error
EX_OK       = 0;          // status for successful termination

// method (subroutine) to output usage message to stderr
def usageMessage() {
   System.err.println("\nYou need to enter one or more numbers:\n")
   System.err.println("   Usage: $SCRIPT_NAME [num1] [num2] [num3]...\n")
   System.exit(EX_USAGE)
}

// method (subroutine) to sum numbers from array
def addNums (Object[] numbers) {
   sum = 0                          // initialize starting sum value
   numbers.each { num ->            // collection loop toprocess numbers
     sum += num.toInteger()         // sum up nums
   }
   println "The summation is: $sum" // output results
   System.exit(EX_OK)
}

// check for only 2 arguments
if (ARG_COUNT < 1)
   // ouptut usage statement to standard error
   usageMessage()
else
   // call addNums to process arguments
   addNums(args)
