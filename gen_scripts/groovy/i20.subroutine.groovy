#!/usr/bin/env groovy
// declare some binding variables
pond     = 500 // pond contains some available fish
captured = 0   // captured represents fish capture
// utility variable, contains message for output
notice   = "Fishing from a local pond... We now have %s in the main pond.\n"

// create subroutine called fish
def fish() {
    Integer pond = 500 // declare local variable
    pond -= 150        // subtract fish from local pond
    captured += 150    // add to the fish captured
}
    
// output result of fish captured from local resource   
printf "We have %s in this pond.\n", pond

fish()              // get some fish
printf notice, pond // output result

fish()              // get some fish
printf notice, pond // output result

fish()              // get some fish
printf notice, pond // output result

// output result of fish captured from shared resource
printf "We now have a total of %s fish captured\n", captured