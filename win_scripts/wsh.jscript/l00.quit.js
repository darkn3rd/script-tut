var arg_count   = WScript.Arguments.Count() // get num of arguments
var script_name = WScript.ScriptName        // get script name
EX_USAGE        = 64                 // status for command line usage error
EX_OK           = 0                  // status for successful termination

// check for only two arguments
if (WScript.Arguments.Count() < 1) {
  usage_message();
} else {
  addNums(WScript.Arguments);
}

// function to print usage message
function usage_message() 
{
    // print helpful instructions
    WScript.StdErr.Write("\nYou one or more numbers:\n\n" +
                         "   Usage: " + script_name + " [num1] [num2] [num3]" +
                         "...\n"
                         );
    WScript.Quit(EX_USAGE);    // return exit code of EX_USAGE
}

// function to add up numbers
function addNums(numbers) 
{ 
  // general purpose loose to enumerate numbers
  // Note: numbers is not an Array, but rather a Collection object
  for (num = 0, sum = 0; num < numbers.length; num++) {
      sum += parseInt(numbers(num));
  }

  WScript.echo("The summation is " + sum + "."); // output result
  WScript.Quit(EX_OK);                           // unnecessary as defaults to 0
}