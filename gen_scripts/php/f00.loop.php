#!/usr/bin/env php
<?php
// testbox: requires=posix
// testbox: title="shell_exec (ls) with foreach collection"
// collection loop on results
foreach (preg_split("/\s+/", rtrim(shell_exec('ls dirtest'))) as $item) {
   if (is_dir("dirtest/$item")) {
       echo "$item is a directory\n";
   } else {
       echo "$item is not a directory\n";
   }
}
?>
