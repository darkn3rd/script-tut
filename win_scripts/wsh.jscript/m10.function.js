// create function
function capitalize(string)
{
  return string.toUpperCase(); // return fully upppercase string
}

WScript.Echo("The current string is: \"ibm\".")
// call the function
result = capitalize("ibm")

// output results
WScript.Echo("The capitalized string is: \"" + result + "\".");
