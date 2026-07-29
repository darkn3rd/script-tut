package main

import (
	"fmt"
	"os"
	"strconv"
)

const (
	exUsage = 64
	exOK    = 0
)

func usageMessage(scriptName string) {
	fmt.Fprintln(os.Stderr)
	fmt.Fprintln(os.Stderr, "You need to enter one or more numbers:")
	fmt.Fprintln(os.Stderr)
	fmt.Fprintln(os.Stderr, "   Usage: "+scriptName+" [num1] [num2] [num3]...")
	fmt.Fprintln(os.Stderr)
	os.Exit(exUsage)
}

func addNums(numbers []string) {
	sum := 0
	for _, num := range numbers {
		n, _ := strconv.Atoi(num)
		sum += n
	}
	fmt.Printf("The summation is: %d.\n", sum)
	os.Exit(exOK)
}

func main() {
	scriptName := os.Args[0]
	args := os.Args[1:]

	if len(args) < 1 {
		usageMessage(scriptName)
	} else {
		addNums(args)
	}
}
