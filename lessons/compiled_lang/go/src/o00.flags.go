package main

import (
	"fmt"
	"os"
)

// The "flag" package enforces its own conventions (e.g. mandatory "--"
//  prefixes, and no clean way to handle "-?") that don't match this
//  lesson's exact flag set, so os.Args is walked by hand instead.
func usage(out *os.File, scriptName string) {
	fmt.Fprintln(out)
	fmt.Fprintln(out, "Usage: "+scriptName+" [-c|-e|-l|-k|-p|-m|-t] [-h|-?]")
	fmt.Fprintln(out)
	fmt.Fprintln(out, "  -c  Coffee")
	fmt.Fprintln(out, "  -e  Espresso")
	fmt.Fprintln(out, "  -l  Latte")
	fmt.Fprintln(out, "  -k  Machiato")
	fmt.Fprintln(out, "  -p  Capucino")
	fmt.Fprintln(out, "  -m  Mocha")
	fmt.Fprintln(out, "  -t  Tea")
	fmt.Fprintln(out, "  -h  Display this help message")
	fmt.Fprintln(out, "  -?  Display this help message")
	fmt.Fprintln(out)
}

func main() {
	scriptName := os.Args[0]
	args := os.Args[1:]

	if len(args) == 0 {
		usage(os.Stderr, scriptName)
		os.Exit(1)
	}

	switch args[0] {
	case "-c":
		fmt.Println("You ordered a Coffee.")
	case "-e":
		fmt.Println("You ordered an Espresso.")
	case "-l":
		fmt.Println("You ordered a Latte.")
	case "-k":
		fmt.Println("You ordered a Machiato.")
	case "-p":
		fmt.Println("You ordered a Capucino.")
	case "-m":
		fmt.Println("You ordered a Mocha.")
	case "-t":
		fmt.Println("You ordered a Tea.")
	case "-h", "-?":
		usage(os.Stdout, scriptName)
	default:
		usage(os.Stderr, scriptName)
		os.Exit(1)
	}
}
