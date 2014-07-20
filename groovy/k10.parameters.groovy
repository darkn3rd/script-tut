#!/usr/bin/env groovy

// create the subroutine
def addNums (Object[] numbers) {
   sum = 0                              // initialize starting sum value
   for (num in numbers)                 // collection loop to get each number
      sum += num                        // sum up nums
   printf "The summation is: %d\n", sum // output results
}

println "Sending: 5, 2, 4, 3, 6"
// call the subroutine
addNums(5, 2, 4, 3, 6)   // pass a series of numbers
