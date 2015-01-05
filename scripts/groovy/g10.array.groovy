#!/usr/bin/env groovy
// create a populated list
nicknames = ["bob","ed","steve","ralph","joe","deb","kate"]

// output the list, one item per line
println "The names are: "
// utilize collection loop to enumerate list
for (name in nicknames)
    println "  $name"
