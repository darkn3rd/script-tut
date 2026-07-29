package main

import "fmt"

var pond = 500 // never mutated - fish() only touches its own local copy
var captured = 0

func fish() {
	pond := 500 // shadows the package-level pond for the rest of this function
	pond -= 150
	captured += 150
}

func main() {
	fmt.Printf("We have %d in this pond.\n", pond)

	fish()
	fmt.Printf("Fishing from a local pond... We now have %d in the main pond.\n", pond)

	fish()
	fmt.Printf("Fishing from a local pond... We now have %d in the main pond.\n", pond)

	fish()
	fmt.Printf("Fishing from a local pond... We now have %d in the main pond.\n", pond)

	fmt.Printf("We now have a total of %d fish captured\n", captured)
}
