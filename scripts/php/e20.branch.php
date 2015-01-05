#!/usr/bin/env php
<?php
echo "Input a character: "; $Keypress = fgetc(STDIN);
 
if (preg_match("/[a-z]/", $Keypress)) {
    echo "Lowercase letter\n";
} elseif (preg_match("/[A-Z]/", $Keypress)) {
    echo "Uppercase letter\n";
} elseif (preg_match("/[0-9]/", $Keypress)) {
    echo "Digit\n";
} else {
    echo "Punctuation, whitespace, or other\n";
}
?>
