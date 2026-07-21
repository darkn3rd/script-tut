#!/usr/bin/env groovy
// get input from user and store as name variable
//   System.console() is null when stdin isn't an interactive terminal
//   (e.g. piped input), so read from System.in directly instead
print "Enter your name: "
name = System.in.newReader().readLine()

// output variable
printf "Hello %s!\n", name