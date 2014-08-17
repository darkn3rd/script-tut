#!/usr/bin/env pash
"The arguments passed are (reverse order):"
foreach($count in $args.Count..1) {  # collection loop on decremented range
  $arg = $args[$count-1]             # retreive exact item
  " item ${count}: ${arg}"           # output results
}