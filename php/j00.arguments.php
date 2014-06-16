#!/usr/bin/php
<?php
// acquire num of args and script name
$arg_count   = $argc - 1;  // get num of arguments
$script_name = $argv[0];   // get script name

if ($arg_count != 2) 
   echo "You need to enter two numbers: \"$script_name\" num1 num2.\n";
 else 
   echo  "The sum of $argv[1] and $argv[2] is: ", $argv[1] + $argv[2], ".\n";
?>