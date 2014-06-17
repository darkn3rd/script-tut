#!/usr/bin/php
<?php
$count       = 1;        // set initial counter
$script_name = $argv[0]; // get script name

echo "The arguments passed are:\n";
// collection loop to enumerate args
foreach ($argv as $arg) {
  // skip if we get name of the script 
  if ("$arg" == "$script_name" ) continue;
  // output count and argument
  echo "  item $count: $arg\n";
  $count++;              // increment counter
}
?>