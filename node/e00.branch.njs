#!/usr/bin/node
WScript.stdout.write("Input a number: ");
number = WScript.stdin.readline();

if (number > 0)                             // automatic coercion to int
   console.log("Number is greater than 0");
else if (number < 0)  
   console.log("Number is less than 0");
else 
   console.log("Number is 0");
