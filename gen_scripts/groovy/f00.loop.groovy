#!/usr/bin/env groovy
// use collection loop on directory listing
//  item represents the file name
for (item in new File('dirtest').list()) {
    if (new File("dirtest/${item}").isDirectory())
        println "$item is a directory"
    else
        println "$item is not a directory"
}
