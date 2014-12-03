#!/usr/bin/node
process.stdout.write("Input a number: ");
process.stdin.on('data', processNumber);  // attach listener

// processNumber is called when user hits return key
function processNumber(number) {

  if (number > 0)   // automatic coercion to int
     console.log("Number is greater than 0");
  else if (number < 0)  
     console.log("Number is less than 0");
  else 
     console.log("Number is 0");
  
  process.exit();
}