#!/usr/bin/php
<?php
// do...while construction
do {
    echo "Enter your name (quit to Exit): ";
    $answer = fgets(STDIN);
    if ($answer != "quit\n") {
        echo "Hello $answer";
    }
} while ($answer != "quit\n");
?>
