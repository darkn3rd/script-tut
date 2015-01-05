#!/usr/bin/env groovy
nicknames = []           // create an empty list

// populate list one item at a time 
nicknames << "bob"
nicknames << "ed"
nicknames << "steve"
nicknames << "ralph"
nicknames << "joe"
nicknames << "deb"
nicknames << "kate"

// output length and all values 
println "The total nicknames are: ${nicknames.size()}"
println "The nicknames are: ${nicknames}"
