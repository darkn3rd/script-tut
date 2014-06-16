#!/usr/bin/php
<?php
// create subroutine
function  show_date() {
  // WARNING: In php.ini, date.timezone must be set for this to work.
  echo "Today is ",  strftime("%B %d, %Y"), "\n";
}

show_date(); // call subroutine
?>