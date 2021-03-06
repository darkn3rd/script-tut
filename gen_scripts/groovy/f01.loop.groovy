#!/usr/bin/env groovy
// iterate through each item in current directory
//   item represents a File object
new File('dirtest').eachFile() { item ->
    if (item.isDirectory())
        println "${item.getName()} is a directory"
    else
        println "${item.getName()} is not a directory"
}
