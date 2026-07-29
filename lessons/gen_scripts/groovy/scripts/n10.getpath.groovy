#!/usr/bin/env groovy
// Split the PATH environment variable on its OS-native delimiter and
//  print each entry on its own line. A given PATH value never mixes
//  both delimiters, so checking for a semicolon first is enough to
//  tell which one actually applies.
def path = System.getenv("PATH")
def delim = path.contains(";") ? ";" : ":"
path.split(delim).each { println it }
