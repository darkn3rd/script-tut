#!/usr/bin/php
<?php
echo "Input a character: "; $Keypress = fgetc(STDIN);
 
switch (TRUE) {
  case preg_match("/[[:lower:]]/", $Keypress):
    echo "Lowercase letter\n";
    break;
  case preg_match("/[[:upper:]]/", $Keypress):
    echo "Uppercase letter\n";
    break;
  case preg_match("/[[:digit:]]/", $Keypress):
    echo "Digit\n";
    break;
  default:
    echo "Puncuation, whitespace, or other\n";
}
?>
