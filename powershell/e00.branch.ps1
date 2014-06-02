# prompt user and get input
$number = [int](Read-Host "Input a number: ")
# evaluate input and print result
if ( $number -gt 0 ) {
  "Number is greater than 0"
} elseif ( $number -lt 0 ) {
  "Number is less than 0"
} else {
  "Number is 0"
}
