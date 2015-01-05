#!/usr/bin/env php
<?php
// collection loop on results
foreach (preg_split("/\s+/", shell_exec('ls')) as $item) {
   if (is_dir($item)) {
       echo "$item is a directory\n";
   } else {
       echo "$item is not a directory\n";
   }
}
?>
