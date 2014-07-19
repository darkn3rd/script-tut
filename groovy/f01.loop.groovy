#!/usr/bin/env groovy
 
// iterate through each item in current directory
//   Note: Demonstrates using raw subshell to get at data
"ls -l".execute().text.eachLine { line -> 
	(perms,item) = line.split()[0,-1]

	if (perms =~ /^d/)
	    println "${item} is a directory"
	else
	    println "${item} is a not a directory"
}