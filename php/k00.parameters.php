#!/usr/bin/php
<?php
// create subroutine
function celsius($fahrenheit) {
  // convert to new temperature
  $temperature = ($fahrenheit - 32) * 5 / 9;
  // format to one significant digits
  $temperature = number_format($temperature, 1, '.', '');
  // output results
  echo "The Celsius temperature is $temperature degrees.\n";
}

$temperature = 73;       // store original temperature
celsius($temperature);   // call function to convert and output results

?>