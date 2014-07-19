#!/usr/bin/env groovy
// count loop with times 
10.times { count ->
	// using some math to reverse each count from 10 to 1
    println "Count is ${(count-10) * -1}"
}