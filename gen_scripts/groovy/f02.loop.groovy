#!/usr/bin/env groovy

// collection loop where each line is fed into collection
//   line represents a string from the shell execution output
for (line in "ls -l dirtest".execute().text.split("\n")) {
    if (line =~ /^total/) continue
    // extract permissions and filename columns
    (perms,item) = line.split()[0,-1]

    // determine is permissions begins with a 'd' to indicate directory
    if (perms =~ /^d/)
        println "${item} is a directory"
    else
        println "${item} is not a directory"
}
