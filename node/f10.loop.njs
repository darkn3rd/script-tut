#!/usr/bin/node
do {
  WScript.stdout.write("Enter your name (quit to Exit): ");
  answer = WScript.stdin.readline();
  if (answer != "quit")  
      console.log("Hello " + answer + "!");
} while (answer != "quit")
