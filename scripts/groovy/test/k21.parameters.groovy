#!/usr/bin/env groovy

// create the subroutine
def swapper(args) {
   // args[1,0] = args[0,1]
   //Integer temp = args[0]
   args[0] = 4
   //args[1] = temp
}

// Create intial variables to be swapped
Integer left  = 0
Integer right = 1

// Output Status before the swap
println "The values before are: Left=$left, Right=$right"

// call the subroutine
swapper([left, right])


// Output Status after the swap
println "The values after are: Left=$left, Right=$right"
