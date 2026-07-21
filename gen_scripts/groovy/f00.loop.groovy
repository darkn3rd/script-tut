#!/usr/bin/env groovy
// use collection loop on directory listing
//  item represents the file name
//  File.list() order isn't guaranteed by the filesystem, so sort it
for (item in new File('dirtest').list().sort()) {
    if (new File("dirtest/${item}").isDirectory())
        println "$item is a directory"
    else
        println "$item is not a directory"
}
