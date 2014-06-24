#!/usr/bin/php
<?php
// conditional loop with while
while  ($answer != "quit") {
    echo "Enter your name (quit to Exit): ";  # output prompt
    $answer = rtrim(fgets(STDIN));            # get input, trim newline
    if ($answer != "quit")
        echo "Hello $answer!\n";              # output result if not exiting
}
?>
