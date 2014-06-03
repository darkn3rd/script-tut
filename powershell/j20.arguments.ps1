"The arguments passed are (reverse order):"
foreach($count in $args.Count..1) { 
  $arg = $args[$count-1]
  " item ${count}: ${arg}" 
}