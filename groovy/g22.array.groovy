#!/usr/bin/env groovy
// create a populated list
nicknames = ["bob","ed","steve","ralph","joe","deb","kate"]

// output the list with index, one item per line
println "The names are: "
// utitlize count style loop to enumerate list
nicknames.eachWithIndex{ nickname, count ->	
    println " nicknames[${count}]=${nickname}"
}