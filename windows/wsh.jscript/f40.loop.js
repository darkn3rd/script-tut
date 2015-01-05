// spin loop as condition is always true
//  use break to exit out of loop
do {
  // prompt user
  WScript.stdout.write("Enter your name (quit to Exit): ");
  answer = WScript.stdin.readline();         // get input
  
  // skip loop if user enters nothing
  if (RegExp("^$").test(answer)) continue 
  
  // exit loop is user quits
  if (answer == "quit") break                                  
	  
  // output result as not exiting	  
  WScript.echo("Hello " + answer + "!"); 
} while (true)
