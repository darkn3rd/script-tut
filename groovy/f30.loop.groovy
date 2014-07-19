#!/usr/bin/env groovy
// spin loop as always true condition
while (true) {
  // print a prompt and get answer
  answer = System.console().readLine "Enter your name (quit to Exit): "

  // determine if user wants to exit loop
  if (answer == "quit")
    break                  // exit loop as user wants to quit

  println "Hello $answer!" // output result as we are not exiting
}