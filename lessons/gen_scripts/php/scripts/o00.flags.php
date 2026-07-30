#!/usr/bin/env php
<?php
// PHP's getopt() doesn't reliably recognize "?" as an option character
//  (it silently finds nothing for -?, even with "?" in the optstring) -
//  so -? is detected with a plain in_array() check against $argv instead.
$usage = "\nUsage: {$argv[0]} [-c|-e|-l|-k|-p|-m|-t] [-h|-?]\n\n" .
         "  -c  Coffee\n" .
         "  -e  Espresso\n" .
         "  -l  Latte\n" .
         "  -k  Machiato\n" .
         "  -p  Capucino\n" .
         "  -m  Mocha\n" .
         "  -t  Tea\n" .
         "  -h  Display this help message\n" .
         "  -?  Display this help message\n\n";

$opts = getopt("celkpmth");

if (isset($opts["c"])) { echo "You ordered a Coffee.\n"; exit(0); }
if (isset($opts["e"])) { echo "You ordered an Espresso.\n"; exit(0); }
if (isset($opts["l"])) { echo "You ordered a Latte.\n"; exit(0); }
if (isset($opts["k"])) { echo "You ordered a Machiato.\n"; exit(0); }
if (isset($opts["p"])) { echo "You ordered a Capucino.\n"; exit(0); }
if (isset($opts["m"])) { echo "You ordered a Mocha.\n"; exit(0); }
if (isset($opts["t"])) { echo "You ordered a Tea.\n"; exit(0); }
if (isset($opts["h"]) || in_array("-?", $argv)) { echo $usage; exit(0); }

fwrite(STDERR, $usage);
exit(1);
?>
