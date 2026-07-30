package main

import (
	"fmt"
	"os"
)

func usage(out *os.File, scriptName string) {
	fmt.Fprintln(out)
	fmt.Fprintln(out, "Usage: "+scriptName+" [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]")
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

	var orders []string
	for _, arg := range args {
		switch arg {
		case "-c":
			orders = append(orders, "coffee")
		case "-e":
			orders = append(orders, "espresso")
		case "-l":
			orders = append(orders, "latte")
		case "-k":
			orders = append(orders, "macchiato")
		case "-p":
			orders = append(orders, "capucino")
		case "-m":
			orders = append(orders, "mocha")
		case "-t":
			orders = append(orders, "tea")
		case "-h", "-?":
			usage(os.Stdout, scriptName)
			os.Exit(0)
		default:
			usage(os.Stderr, scriptName)
			os.Exit(1)
		}
	}

	fmt.Println()
	fmt.Println("You ordered: ")
	for _, drink := range orders {
		fmt.Println("* " + drink)
	}
}
