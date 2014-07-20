#!/usr/bin/env groovy
// initialize dictionary with key/value pairs
ages = ["bob": 34, "ed": 58, "steve": 32, "ralph": 23]

// append another set of key/value pairs into dictionary
ages += ["deb": 46, "kate": 19]
 
// output the dictionary with key, one item per line
print "The ages are: "
ages.each { name, age ->
    println " ages[$name]=${age}"
}