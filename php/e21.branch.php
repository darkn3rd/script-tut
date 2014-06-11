#!/usr/bin/php
<?php
echo "Input a character: "; $Keypress = fgetc(STDIN);
 
if (preg_match("/[[:lower:]]/", $Keypress)) {
    echo "Lowercase letter\n";
} elseif (preg_match("/[[:upper:]]/", $Keypress)) {
    echo "Uppercase letter\n";
} elseif (preg_match("/[[:digit:]]/", $Keypress)) {
    echo "Digit\n";
} else {
    echo "Punctuation, whitespace, or other\n";
}
?>
