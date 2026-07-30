#!/usr/bin/env php
<?php
// testbox: requires=posix
// create subroutine
function  show_date() {
  // strftime() is deprecated since PHP 8.1; use date() instead. PHP has
  // no reliable way to auto-detect the host's local timezone (date.timezone
  // in php.ini defaults to UTC), so derive it from /etc/localtime.
  $tz = @readlink("/etc/localtime");
  $tz = preg_replace("#.*/zoneinfo/#", "", $tz);
  date_default_timezone_set($tz ?: "UTC");

  $date = date("F d, Y");
  echo "Today is $date.\n";
}

show_date(); // call subroutine
?>
