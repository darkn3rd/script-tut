#!/usr/bin/env groovy
 
print "Input a character: "   // output prompt w/o newline
//character = sys.stdin.read(1)              # read one character

character = (char) System.in.read()

// output results of character captured 
printf "You entered: >>|%c|<<.\n",  character