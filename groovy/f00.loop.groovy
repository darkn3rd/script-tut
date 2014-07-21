#!/usr/bin/env groovy
// use collection loop on directory listing
//  item represents the file name
for (item in new File('.').list()) { 
	if (new File(item).isDirectory())
		println "$item is a directory"
	else
	    println "$item is a not a directory"
}
