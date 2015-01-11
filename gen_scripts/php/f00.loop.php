#!/usr/bin/env php
<?php
// collection loop on results
foreach (preg_split("/\s+/", rtrim(shell_exec('ls dirtest'))) as $item) {
   if (is_dir("dirtest/$item")) {
       echo "$item is a directory\n";
   } else {
       echo "$item is not a directory\n";
   }
}
?>
