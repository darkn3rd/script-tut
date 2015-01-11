#!/usr/bin/env groovy
nicknames = []           // create an empty list

// populate list one item at a time 
nicknames[0] = "bob"
nicknames[1] = "ed"
nicknames[2] = "steve"
nicknames[3] = "ralph"
nicknames[4] = "joe"
nicknames[5] = "deb"
nicknames[6] = "kate"

// output length and all values 
println "The total nicknames are: ${nicknames.size()}"
println "The nicknames are: ${nicknames}"
