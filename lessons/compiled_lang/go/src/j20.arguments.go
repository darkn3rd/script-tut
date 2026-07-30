package main

import (
	"fmt"
	"os"
)

func main() {
	args := os.Args[1:]

	fmt.Println("The arguments passed are (reverse order):")
	for i := len(args) - 1; i >= 0; i-- {
		fmt.Printf(" item %d: %s\n", i+1, args[i])
	}
}
