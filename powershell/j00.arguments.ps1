if ($args.Count -ne 2) {
   $ScriptName = $MyInvocation.MyCommand.Name
   "You need to enter two numbers: `n`n`t${ScriptName} num1 num2" 
} else {
  "The sum of ${args[0]} and ${args[1]} is: $($args[0] + $args[1])"
}