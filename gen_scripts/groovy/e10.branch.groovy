#!/usr/bin/env groovy
// get input from user
//   System.console() is null when stdin isn't an interactive terminal
//   (e.g. piped input), so read from System.in directly instead
print "Would you like a toast? [Yes/No]: "
response = System.in.newReader().readLine()

// set response string using one line (ternary-like statement)
//   Test response to a string
response_str = (response == "Yes") ? "That's great!" : "How about a muffin?"

// output the response string
println response_str
