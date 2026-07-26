#!/usr/bin/env php
<?php
// getopt() can't easily be told "collect flags in the order they were
//  given, allowing repeats" - it fills one fixed destination per flag -
//  so this is parsed by hand instead, matching the technique used
//  across every other language's o20 lesson.
$usage = "\nUsage: {$argv[0]} [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]\n\n" .
         "  --coffee,    -c N  Coffee\n" .
         "  --espresso,  -e N  Espresso\n" .
         "  --latte,     -l N  Latte\n" .
         "  --macchiato, -k N  Machiato\n" .
         "  --capucino,  -p N  Capucino\n" .
         "  --mocha,     -m N  Mocha\n" .
         "  --tea,       -t N  Tea\n" .
         "  --help,      -h    Display this help message\n" .
         "  -?                 Display this help message\n\n";

$flags = [
    "--coffee" => "coffee", "-c" => "coffee",
    "--espresso" => "espresso", "-e" => "espresso",
    "--latte" => "latte", "-l" => "latte",
    "--macchiato" => "macchiato", "-k" => "macchiato",
    "--capucino" => "capucino", "-p" => "capucino",
    "--mocha" => "mocha", "-m" => "mocha",
    "--tea" => "tea", "-t" => "tea",
];

$rest = array_slice($argv, 1);
$orders = [];
$i = 0;
while ($i < count($rest)) {
    $arg = $rest[$i];
    if ($arg === "--help" || $arg === "-h" || $arg === "-?") {
        echo $usage;
        exit(0);
    } elseif (isset($flags[$arg])) {
        $name = $flags[$arg];
        $n = (int)$rest[$i + 1];
        $orders[] = "$n " . ($n == 1 ? $name : $name . "s");
        $i += 2;
    } else {
        fwrite(STDERR, $usage);
        exit(1);
    }
}

if (empty($orders)) {
    fwrite(STDERR, $usage);
    exit(1);
}

echo "\n";
echo "You ordered: \n";
foreach ($orders as $order) {
    echo "* $order\n";
}
?>
