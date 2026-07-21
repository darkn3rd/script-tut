#!/usr/bin/env groovy
// iterate through each item in current directory
//   item represents a File object
//   eachFile() order isn't guaranteed by the filesystem, so sort first
new File('dirtest').listFiles().sort().each { item ->
    if (item.isDirectory())
        println "${item.getName()} is a directory"
    else
        println "${item.getName()} is not a directory"
}
