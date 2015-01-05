#!/usr/bin/env groovy
// get input from user
response = System.console().readLine "Would you like a toast? [Yes/No]: "

// set response string using one line (ternary-like statement)
//   Test response to a string
response_str = (response == "Yes") ? "That's great!" : "How about a muffin?"

// output the response string
println response_str
