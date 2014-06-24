#!/usr/bin/php
<?php
// spin loop as always true
//   break used to exit loop
do {
    echo "Enter your name (quit to Exit): "; # output prompt
    $answer = rtrim(fgets(STDIN));           # get input, trim newline
    if ($answer == "quit")
         break;                              # exit loop if user quits
    else
        echo "Hello $answer!\n";             # output results as not exiting
} while (1);
?>
