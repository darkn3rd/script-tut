#!/usr/bin/php
<?php
// foreach (as) construction
foreach (preg_split("/\s+/", shell_exec('ls')) as $item) {
   if (is_dir($item)) {
       echo "$item is a directory\n";
   } else {
       echo "$item is not a directory\n";
   }
}
?>
