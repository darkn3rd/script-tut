#!/usr/bin/env groovy
// spin loop as always true condition
while (true) {
  // print a prompt and get answer
  answer = System.console().readLine "Enter your name (quit to Exit): "
  
  // skip loop if user enters an empty string
  if (answer =~ /^[\s\t]*$/)
    continue             // skip to next loop
  
  // determine if user wants to exit loop
  if (answer == "quit")
    break                // exit loop if user wants to quit

  println "Hello $answer!" // output result as we are not exiting
}