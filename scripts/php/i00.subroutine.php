#!/usr/bin/env php
<?php
// create subroutine
function  show_date() {
  // WARNING: In php.ini, date.timezone must be set for this to work.
  $date = strftime("%B %d, %Y");
  echo "Today is $date.\n";
}

show_date(); // call subroutine
?>