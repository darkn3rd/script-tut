#!/usr/bin/env groovy
answer = ""  // required to initialize answer before testing it

// conditonal loop with while
while (answer != "quit") {
  // output a prompt and get answer
  answer = System.console().readLine "Enter your name (quit to Exit): "

  // output answer if not quitting
  if (answer != "quit")
    println "Hello $answer!" // output results if not exiting
}