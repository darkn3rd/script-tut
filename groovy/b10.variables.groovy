#!/usr/bin/env groovy
// declare the variables
num    = 5                   // defaults to java.lang.Integer
chr    = 'a'                 // defaults to java.lang.String
string = "This is a string"  // defaults to java.lang.String
 
// output variables using interpolation
println "Number is $num."
println "Character is a '$chr'."
println "String is \"$string\"." // must escape quotes