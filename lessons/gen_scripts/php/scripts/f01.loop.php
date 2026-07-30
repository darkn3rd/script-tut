#!/usr/bin/env php
<?php
// testbox: title="scandir() with foreach collection"
// collection loop on results from PHP's own scandir(), without a
//  subshell - see f00.loop.php for the shell_exec (`ls`) version of
//  this same lesson
foreach (array_diff(scandir("dirtest"), [".", ".."]) as $item) {
   if (is_dir("dirtest/$item")) {
       echo "$item is a directory\n";
   } else {
       echo "$item is not a directory\n";
   }
}
?>
