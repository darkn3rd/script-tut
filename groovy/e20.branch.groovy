#!/usr/bin/env groovy
// prompt, get input, and convert to integer
//number = int(raw_input("Input a number: "))
number = System.console().readLine("Input a number: ").toInteger()

// test number range 
if (number > 0) {
  println "Number is greater than 0"
} else if (number < 0) {
  println "Number is less than 0"
} else {
  println "Number is 0"
}
