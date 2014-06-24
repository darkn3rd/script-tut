// spin loop as condition is always true
//  use break to exit out of loop
do {
  // prompt user
  WScript.stdout.write("Enter your name (quit to Exit): ");
  answer = WScript.stdin.readline();         // get input
  if (answer == "quit")
      break                                  // exit loop is user quits
  else	  
      WScript.echo("Hello " + answer + "!"); // output result as not exiting
} while (true)
