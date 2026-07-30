#!/usr/bin/env groovy
// spin loop as always true condition
//   System.console() is null when stdin isn't an interactive terminal
//   (e.g. piped input), so read from System.in directly instead; the
//   reader is created once, outside the loop, so repeated reads don't
//   each re-wrap System.in and lose any buffered input
stdin = System.in.newReader()
while (true) {
  // print a prompt and get answer
  print "Enter your name (quit to exit): "
  answer = stdin.readLine()
  
  // skip loop if user enters an empty string
  if (answer =~ /^[\s\t]*$/)
    continue             // skip to next loop
  
  // determine if user wants to exit loop
  if (answer == "quit")
    break                // exit loop if user wants to quit

  println "Hello $answer!" // output result as we are not exiting
}
