"The arguments passed are:"
foreach($count in 1..$args.Count) { 
  $arg = $args[$count-1]             # retreived exact item
  " item ${count}: ${arg}"           # output results
}