#!/usr/bin/env groovy
// iterate through each item in current directory
//   line represents a string from the shell execution output
"ls -l dirtest".execute().text.eachLine { line -> 
    // extract permissions and filename columns
    (perms,item) = line.split()[0,-1]

    // determine is permissions begins with a 'd' to indicate directory
    if (perms =~ /^d/)
        println "${item} is a directory"
    else
        println "${item} is a not a directory"
}
