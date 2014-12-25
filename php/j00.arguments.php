#!/usr/bin/env php
<?php
// acquire num of args and script name
$arg_count   = $argc - 1;  // get num of arguments
$script_name = $argv[0];   // get script name

if ($arg_count != 2) {
   # output usage statment to standard error
   fwrite(STDERR, "\nYou need to enter two numbers: \n\n");
   fwrite(STDERR, "   Usage: $script_name [num1] [num2]\n\n");
} else {
  $sum = $argv[1] + $argv[2]; // get sum of both arguments
  // print results of both arguments and summation
  echo  "The sum of $argv[1] and $argv[2] is: $sum.\n";
}
?>