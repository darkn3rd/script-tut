#!/usr/bin/env groovy
// prompt, get input, and convert to integer
//   System.console() is null when stdin isn't an interactive terminal
//   (e.g. piped input), so read from System.in directly instead
print "Input a number: "
number = System.in.newReader().readLine().toInteger()

// test number range 
if (number > 0) {
  println "Number is greater than 0"
} else if (number < 0) {
  println "Number is less than 0"
} else {
  println "Number is 0"
}
