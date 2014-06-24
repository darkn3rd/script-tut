#!/usr/bin/php
<?php
// conditional loop
while  ($answer != "quit") {
    echo "Enter your name (quit to Exit): ";
    $answer = rtrim(fgets(STDIN));
    if ($answer != "quit")
        echo "Hello $answer!\n";
}
?>
