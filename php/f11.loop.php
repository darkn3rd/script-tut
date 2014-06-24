#!/usr/bin/php
<?php
// count loop using range to generate sequence
//   which is then fed into collection loop
foreach (array_reverse(range(1, 10)) as $count) {
    echo "Count is $count\n";
}
?>
