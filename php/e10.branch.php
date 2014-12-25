#!/usr/bin/env php
<?php
echo "Input a character: "; $Keypress = fgetc(STDIN);
 
switch (TRUE) {
  case preg_match("/[a-z]/", $Keypress):
    echo "Lowercase letter\n";
    break;
  case preg_match("/[A-Z]/", $Keypress):
    echo "Uppercase letter\n";
    break;
  case preg_match("/[0-9]/", $Keypress):
    echo "Digit\n";
    break;
  default:
    echo "Puncuation, whitespace, or other\n";
}
?>
