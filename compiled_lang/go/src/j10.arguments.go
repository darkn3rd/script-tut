package main

import (
	"fmt"
	"os"
)

func main() {
	args := os.Args[1:]

	fmt.Println("The arguments passed are:")
	for i, arg := range args {
		fmt.Printf(" item %d: %s\n", i+1, arg)
	}
}
