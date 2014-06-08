#!/usr/bin/php
<?php
echo "Input a number: "; $Number = fgets(STDIN);
 
if ($Number > 0) {
  echo "Number is greater than 0";
} elseif ($Number < 0) {
  echo "Number is less than 0";
} else {
  echo "Number is 0";
}
?>
