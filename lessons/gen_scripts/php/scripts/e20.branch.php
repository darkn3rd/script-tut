#!/usr/bin/env php
<?php
echo "Input a number: "; $Number = fgets(STDIN);

if ($Number > 0) {
  echo "Number is greater than 0\n";
} elseif ($Number < 0) {
  echo "Number is less than 0\n";
} else {
  echo "Number is 0\n";
}
?>
