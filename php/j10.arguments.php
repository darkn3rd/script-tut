#!/usr/bin/php
<?php
// acquire num of args
$arg_count   = $argc - 1;  // get num of arguments

// iterative loop to enumerate args
for ( $count = 1; $count <= $arg_count ; $count++ )
  echo "item $count: $argv[$count]\n";
?>