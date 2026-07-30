package main

import "fmt"

// package-level vars are directly visible and mutable from any function
//  in this package - no "global" keyword needed like Python.
var pond = 500
var captured = 0

func fish() {
	pond -= 150
	captured += 150
}

func main() {
	fmt.Printf("We have %d in this pond.\n", pond)

	fish()
	fmt.Printf("Fishing from the main pond... We now have %d in the main pond.\n", pond)

	fish()
	fmt.Printf("Fishing from the main pond... We now have %d in the main pond.\n", pond)

	fish()
	fmt.Printf("Fishing from the main pond... We now have %d in the main pond.\n", pond)

	fmt.Printf("We now have a total of %d fish captured\n", captured)
}
