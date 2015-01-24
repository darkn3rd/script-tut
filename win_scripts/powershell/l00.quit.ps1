#!/usr/bin/env pash
# illustrative variables
$arg_count   = $args.Count                  # get num of real arguments
$script_name = $MyInvocation.MyCommand.Name # get name of script
$EX_USAGE    = 64;                    # status for command line usage error
$EX_OK       = 0;                     # status for successful termination

# print usage message
Function Usage-Message
{
   # print helpful instructions
   [Console]::Error.WriteLine("`nYou need to enter one or more numbers:`n`n" +
                              "   Usage: ${script_name} [num1] [num2] " +
                              "[num3]...`n")
   [Environment]::Exit($EX_USAGE)
}

# add up all the arguments and print results
Function Add-Nums ($nums)
{
   foreach($num in $nums) { $sum += [int]$num }  # iterate and sum up nums
   "The summation is: ${sum}."              # output results

   [Environment]::Exit($EX_OK)
}

if ($arg_count -lt 1) {
    Usage-Message
} else {
    Add-Nums($args)
}
