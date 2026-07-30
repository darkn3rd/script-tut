#!/usr/bin/env php
<?php
$drinks = [
    "Capucino" => 0,
    "Coffee" => 0,
    "Espresso" => 0,
    "Latte" => 0,
    "Machiato" => 0,
    "Mocha" => 0,
    "Tea" => 0,
];

if (count($argv) == 1) {
    foreach ($drinks as $key => $_) {
        $drinks[$key] = rand(0, 2);
    }
} else {
    foreach (array_slice($argv, 1) as $pair) {
        [$key, $qty] = explode(":", $pair, 2);
        $drinks[$key] = (int)$qty;
    }
}

ksort($drinks);
$parts = [];
foreach ($drinks as $key => $qty) {
    if ($qty != 0) {
        $parts[] = "$key:$qty";
    }
}
$order = implode(",", $parts);

// putenv(), not $_ENV - $_ENV only reflects the environment at process
//  startup unless "variables_order" includes "E" and is refreshed;
//  putenv() actually updates the process's real environment, which
//  getenv()/proc_open() children and this lesson's own later
//  enumeration both correctly see.
putenv("MY_ORDERS=$order");

// Dump the whole environment (plain "KEY=value" lines) to a well-known
// file for an external observer to inspect while this script is
// paused below - deleted again once that observer is done and this
// script is about to exit.
$fh = fopen("dump_env.out", "w");
foreach (getenv() as $key => $value) {
    fwrite($fh, "$key=$value\n");
}
fclose($fh);

// Explicit flush - stdout is block-buffered (not line-buffered) once
// it's a pipe rather than a real terminal, so without this the prompt
// below might never actually reach the test harness waiting to read it.
echo "MY_ORDERS set, Hit Return to continue\n";
flush();
fgets(STDIN);

unlink("dump_env.out");
?>
