#!/usr/bin/env groovy
// illustrative variables
ARG_COUNT = args.size() // get number of arguments
// utility variables
count     = ARG_COUNT   // initialize counter

println "The arugments passed are:"
// iteration with each to output arg and count
args.reverse().each { arg -> 
	println " item ${count}: $arg" 
    count--
}