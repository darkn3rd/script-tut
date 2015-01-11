#!/usr/bin/env groovy
// create a populated list
nicknames = ["bob","ed","steve","ralph","joe","deb","kate"]

// output the list with index, one item per line
println "The names are: "
// utitlize count style loop to enumerate list
for (count in 0..nicknames.size()-1)
    println " nicknames[${count}]=${nicknames[count]}"