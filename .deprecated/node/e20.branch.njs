#!/usr/bin/node
// prompt and read 1 character
process.stdout.write("Input a character: ");
// attach a listerner to stdin stream async event loop
process.stdin.on('data', processKeypress);   

// functioned to be called when enter key is entered
function processKeypress(keypress) {

  // find RegExp and print result
  if (RegExp("[a-z]").test(keypress)) 
      console.log("Lowercase letter");
  else if (RegExp("[A-Z]").test(keypress)) 
     console.log("Uppercase letter");
  else if (RegExp("[0-9]").test(keypress)) 
      console.log("Digit");
  else 
      console.log("Punctuation, whitespace, or other");
    
  process.exit();
}