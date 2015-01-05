#!/usr/bin/env php
<?php
// illustrative variables
$arg_count = $argc - 1;  // get num of arguments
$first     = 1;          // set index of initial element
$last      = $arg_count; // set index of last element

echo "The arguments passed are (reverse order):\n";
// iterative loop to enumerate args
for ( $count = $last; $count >= $first; $count-- )
  // output count and argument suing count index
  echo "  item $count: $argv[$count]\n";
?>