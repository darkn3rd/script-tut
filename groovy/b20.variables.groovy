#!/usr/bin/env groovy
// declare the variables
num    = 5                   // defaults to java.lang.Integer
chr    = 'a'                 // defaults to java.lang.String
string = "This is a string"  // defaults to java.lang.String
 
// output variables using formatting
printf "Number is %d.\n", num
printf "Character is a '%c'.\n", chr as char // convert to char
printf 'String is "%s".\n', string