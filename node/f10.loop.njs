#!/usr/bin/node

var answer = ""

//do {
// process.stdout.write("Enter your name (quit to Exit): ");

 var readlineSync = require('readline-sync');
 var answer = readlineSync.question('Enter your name (quit to Exit):');

/* process.stdin.once('data', function(data) { 
   answer = data.toString().trim(); 
   process.stdout.write("answer is - " + answer);
 });*/
  
  
// process.exit();  
  //answer = WScript.stdin.readline();
//  if (answer != "quit")  
      console.log("Hello " + answer + "!");
//} while (answer != "quit")


/*************************====>
   http://st-on-it.blogspot.com/2011/05/how-to-read-user-input-with-nodejs.html
,===========*/

/*process.stdout.write("Enter your name (quit to Exit): ");
process.stdin.on('data', processAnswers);

// functioned to be called when enter key is entered
function processAnswers(answer) {
  if (answer != "quit") {
      console.log("Hello " + answer + "!");
      process.stdout.write("Enter your name (quit to Exit): ");
  } else {
      process.exit();
  }
}*/

/*Research into this and this is hard to get working outside of node.js high level async model.

Have to use the 

    fs.readSync(stdin.fd, buffer, 0, BUF_SIZE)

*/