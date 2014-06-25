#!/usr/bin/php
<?php
// illustrative variables
$arg_count = $argc - 1;  // get num of arguments
$first     = 1;          // set index of initial element
$last      = $arg_count; // set index of last element

echo "The arguments passed are:\n";
// iterative loop to enumerate args
for ( $count = $first; $count <= $last ; $count++ )
  // output count and argument using count index
  echo "  item $count: $argv[$count]\n";
?>