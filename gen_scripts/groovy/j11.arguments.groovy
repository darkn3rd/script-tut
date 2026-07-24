#!/usr/bin/env groovy
println "The arguments passed are:"
// iteration with eachWithIndex to output arg and count
args.eachWithIndex{ arg, count -> println " item ${count+1}: $arg" }
