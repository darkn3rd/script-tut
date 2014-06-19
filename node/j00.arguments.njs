#!/usr/bin/node

var arg_count   = WScript.Arguments.Count() // get num of arguments
var script_name = WScript.ScriptName        // get script name

// check for only two arguments
if (WScript.Arguments.Count() != 2) {
 // print helpful instructions
 console.log("\nYou need to enter two numbers:\n");
 console.log("   Usage: " + script_name + " [num1] [num2]");
} else {
 // get sum of both arguments, force cast to integer
 var sum = parseInt(WScript.Arguments.Item(0)) + 
           parseInt(WScript.Arguments.Item(1));
 // print results of both arguments (string) and summation (integer)
 console.log("The sum of " + WScript.Arguments.Item(0) + 
              " and " + WScript.Arguments.Item(1) + 
              " is: " + sum
             );
}

