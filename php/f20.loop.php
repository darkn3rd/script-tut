#!/usr/bin/env php
<?php
// conditional loop with do..while
do {
    echo "Enter your name (quit to Exit): "; # output prompt
    $answer = rtrim(fgets(STDIN));           # get input, trim newline
    if ($answer != "quit")
        echo "Hello $answer!\n";             # output result if not exiting
} while ($answer != "quit");
?>
