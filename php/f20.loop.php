#!/usr/bin/php
<?php
// conditional loop
do {
    echo "Enter your name (quit to Exit): ";
    $answer = rtrim(fgets(STDIN));
    if ($answer != "quit")
        echo "Hello $answer!\n";
} while ($answer != "quit");
?>
