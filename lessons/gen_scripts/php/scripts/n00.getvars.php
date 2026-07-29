#!/usr/bin/env php
<?php
// Enumerate a fixed set of well-known environment variables, printing
// "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
// as actual environment entries on every POSIX host - fall back to
// PHP's own portable equivalent for each (all three work identically on
// Windows) so this stays reliable anywhere. USERNAME/USERPROFILE/TEMP/
// COMPUTERNAME are Windows-only concepts with no POSIX equivalent -
// printed only when actually present.
$user = getenv("USER") !== false ? getenv("USER") : get_current_user();
$tmpdir = getenv("TMPDIR") !== false ? getenv("TMPDIR") : sys_get_temp_dir();
$hostname = getenv("HOSTNAME") !== false ? getenv("HOSTNAME") : gethostname();

echo "USER=$user\n";
echo "HOME=" . getenv("HOME") . "\n";
echo "TMPDIR=$tmpdir\n";
echo "HOSTNAME=$hostname\n";

if (getenv("USERNAME") !== false)     echo "USERNAME=" . getenv("USERNAME") . "\n";
if (getenv("USERPROFILE") !== false)  echo "USERPROFILE=" . getenv("USERPROFILE") . "\n";
if (getenv("TEMP") !== false)         echo "TEMP=" . getenv("TEMP") . "\n";
if (getenv("COMPUTERNAME") !== false) echo "COMPUTERNAME=" . getenv("COMPUTERNAME") . "\n";
?>
