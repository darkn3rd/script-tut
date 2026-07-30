#!/usr/bin/env php
<?php
// getopt() doesn't preserve the order flags were given in (see
//  o00.flags.php for that approach) - a plain $argv loop is used here
//  instead, since the order they were ordered in matters.
$usage = "\nUsage: {$argv[0]} [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]\n\n" .
         "  -c  Coffee\n" .
         "  -e  Espresso\n" .
         "  -l  Latte\n" .
         "  -k  Machiato\n" .
         "  -p  Capucino\n" .
         "  -m  Mocha\n" .
         "  -t  Tea\n" .
         "  -h  Display this help message\n" .
         "  -?  Display this help message\n\n";

$flags = [
    "-c" => "coffee",
    "-e" => "espresso",
    "-l" => "latte",
    "-k" => "macchiato",
    "-p" => "capucino",
    "-m" => "mocha",
    "-t" => "tea",
];

$orders = [];
foreach (array_slice($argv, 1) as $arg) {
    if ($arg === "-h" || $arg === "-?") {
        echo $usage;
        exit(0);
    } elseif (isset($flags[$arg])) {
        $orders[] = $flags[$arg];
    }
}

if (empty($orders)) {
    fwrite(STDERR, $usage);
    exit(1);
}

echo "\n";
echo "You ordered: \n";
foreach ($orders as $drink) {
    echo "* $drink\n";
}
?>
