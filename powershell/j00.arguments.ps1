#!/usr/bin/env pash
$arg_count   = $args.Count                  # get num of real arguments
$script_name = $MyInvocation.MyCommand.Name # get name of script

if ($arg_count -ne 2) {
   # print helpful instructions 
   "`nYou need to enter two numbers: `n"
   "   Usage: ${script_name} [num1] [num2]`n" 
} else {
  $sum = $args[0] + $args[1]                # get sum of both arguments
  # print results of both arguments and summation
  "The sum of ${args[0]} and ${args[1]} is: ${sum}"
}