#!/usr/bin/php
<?php
// acquire num of args
$arg_count   = $argc - 1;  // get num of arguments

echo "The arguments passed are (reverse order):\n";
// iterative loop to enumerate args
for ( $count = $arg_count; $count > 0; $count-- )
  echo "  item $count: $argv[$count]\n";
?>