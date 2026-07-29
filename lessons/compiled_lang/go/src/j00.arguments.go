package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	scriptName := os.Args[0]
	args := os.Args[1:]

	if len(args) != 2 {
		fmt.Fprintln(os.Stderr)
		fmt.Fprintln(os.Stderr, "You need to enter two numbers:")
		fmt.Fprintln(os.Stderr)
		fmt.Fprintln(os.Stderr, "   Usage: "+scriptName+" [num1] [num2]")
		fmt.Fprintln(os.Stderr)
	} else {
		num1, _ := strconv.Atoi(args[0])
		num2, _ := strconv.Atoi(args[1])
		fmt.Printf("The sum of %s and %s is: %d.\n", args[0], args[1], num1+num2)
	}
}
