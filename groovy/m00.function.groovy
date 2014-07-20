#!/usr/bin/env groovy
// create the function
def addNums (Object[] numbers) {
   sum = 0                            // initialize starting sum value
   numbers.each { num -> sum += num } // iterate and sum up nums
   sum                                // return the sum
}

// output numbers before function
println "The numbers to be added are ${[5, 2, 4, 3, 6]}."

// call the function
result = addNums 5, 2, 4, 3, 6

// output results
println "The result of their summation is: $result."
