#!/usr/bin/env php
<?php
// Split the PATH environment variable on its OS-native delimiter and
// print each entry on its own line. A given PATH value never mixes
// both delimiters, so checking for a semicolon first is enough to tell
// which one actually applies.
$path = getenv("PATH");
$delim = strpos($path, ";") !== false ? ";" : ":";
foreach (explode($delim, $path) as $dir) {
    echo "$dir\n";
}
?>
