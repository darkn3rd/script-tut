$count = 1                    # set initial count
"The arguments passed are:"
foreach($arg in $args) {      # collection loop
  " item ${count}: ${arg}"    # print count and current arg
  $count += 1                 # increment count
}
