#!/usr/bin/env groovy
 
// iterate through each item in current directory
//   Note: Demonstrates using Groovy's API to get data
new File('.').eachFile() { item -> 
	if (item.isDirectory())
		println "${item.getName()} is a directory"
	else
	    println "${item.getName()} is a not a directory"
}