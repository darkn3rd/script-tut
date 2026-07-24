#!/usr/bin/env php
<?php
// testbox: title="cross-platform timezone detection (POSIX + Windows)"
// create subroutine
function show_date() {
  // strftime() is deprecated since PHP 8.1; use date() instead. PHP has
  // no built-in cross-platform way to auto-detect the host's local
  // timezone (date.timezone in php.ini defaults to UTC), so this tries
  // both a POSIX and a Windows source before giving up and using UTC.
  // See i00.subroutine.php for the POSIX-only /etc/localtime version.
  $tz = @readlink("/etc/localtime");
  $tz = $tz ? preg_replace("#.*/zoneinfo/#", "", $tz) : null;

  if (!$tz && PHP_OS_FAMILY === "Windows" && extension_loaded("intl")) {
    // tzutil is a native Windows command (no POSIX subshell involved)
    //  that prints the OS's configured timezone, e.g. "Pacific Standard
    //  Time". IntlTimeZone::getIDForWindowsID() maps that Windows-style
    //  name to the IANA name date_default_timezone_set() expects, using
    //  ICU's CLDR mapping data.
    $winTz = trim(shell_exec("tzutil /g") ?: "");
    if ($winTz) {
      $tz = IntlTimeZone::getIDForWindowsID($winTz) ?: null;
    }
  }

  date_default_timezone_set($tz ?: "UTC");

  $date = date("F d, Y");
  echo "Today is $date.\n";
}

show_date(); // call subroutine
?>
