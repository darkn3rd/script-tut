#!/usr/bin/env groovy
// get input from user
//   System.console() is null when stdin isn't an interactive terminal
//   (e.g. piped input), so read from System.in directly instead
print "Would you like a toast? [Yes/No]: "
response = System.in.newReader().readLine()

// set response string using if/else construction
//   Test response to a string
if (response == "Yes") {
  response_str = "That's great!"
} else {
  response_str = "How about a muffin?"
}
// output the response string
println response_str