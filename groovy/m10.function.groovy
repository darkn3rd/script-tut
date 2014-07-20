#!/usr/bin/env groovy
// create the function
def capitalize (string) {
   string.toUpperCase() // return fully uppercase string
}

// output string before calling function
string = "ibm"
println "The current string is: \"$string\"."

// call the function
result = capitalize(string)

// output results after calling function
println "The capitalized string is: \"$result\"."