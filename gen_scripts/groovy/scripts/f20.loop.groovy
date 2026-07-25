#!/usr/bin/env groovy
answer = ""  // required to initialize answer before testing it
//   System.console() is null when stdin isn't an interactive terminal
//   (e.g. piped input), so read from System.in directly instead; the
//   reader is created once, outside the loop, so repeated reads don't
//   each re-wrap System.in and lose any buffered input
stdin = System.in.newReader()

// conditonal loop with while
while (answer != "quit") {
  // output a prompt and get answer
  print "Enter your name (quit to Exit): "
  answer = stdin.readLine()

  // output answer if not quitting
  if (answer != "quit")
    println "Hello $answer!" // output results if not exiting
}
