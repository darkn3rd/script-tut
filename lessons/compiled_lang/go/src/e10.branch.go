package main

import (
	"bufio"
	"fmt"
	"os"
)

// Go has no ternary operator - this generic helper is the common
//  idiomatic stand-in (needs Go 1.18+ generics)
func ternary[T any](cond bool, ifTrue, ifFalse T) T {
	if cond {
		return ifTrue
	}
	return ifFalse
}

func main() {
	stdin := bufio.NewScanner(os.Stdin)
	fmt.Print("Would you like a toast? [Yes/No]: ")
	stdin.Scan()
	response := stdin.Text()

	message := ternary(response == "Yes", "That's great!", "How about a muffin?")

	fmt.Println(message)
}
