#!/usr/bin/env groovy
// create a populated list
nicknames = ["bob","ed","steve","ralph","joe","deb","kate"]

// output the list, one item per line
println "The names are: "
// utitlize iterator to enumerate list
nicknames.each { name->
    println "  $name"
}