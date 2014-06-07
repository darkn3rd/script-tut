// create subroutine
function celsius(fahrenheit) {
  temperature = (fahrenheit - 32) * 5 / 9; // calculate to internatioanl temp
  temperature = temperature.toFixed(1);    // lower degree of significance

  // output results
  WScript.echo("The Celsius temperature is " + temperature + " degrees.");
}

temperature = 73;     // set temp in fahrenheit
celsius(temperature); // call subroutine
