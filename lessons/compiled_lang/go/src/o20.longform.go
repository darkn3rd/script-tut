package main

import (
	"fmt"
	"os"
	"strconv"
)

func usage(out *os.File, scriptName string) {
	fmt.Fprintln(out)
	fmt.Fprintln(out, "Usage: "+scriptName+" [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]")
	fmt.Fprintln(out)
	fmt.Fprintln(out, "  --coffee,    -c N  Coffee")
	fmt.Fprintln(out, "  --espresso,  -e N  Espresso")
	fmt.Fprintln(out, "  --latte,     -l N  Latte")
	fmt.Fprintln(out, "  --macchiato, -k N  Machiato")
	fmt.Fprintln(out, "  --capucino,  -p N  Capucino")
	fmt.Fprintln(out, "  --mocha,     -m N  Mocha")
	fmt.Fprintln(out, "  --tea,       -t N  Tea")
	fmt.Fprintln(out, "  --help,      -h    Display this help message")
	fmt.Fprintln(out, "  -?                 Display this help message")
	fmt.Fprintln(out)
}

func main() {
	scriptName := os.Args[0]
	args := os.Args[1:]

	if len(args) == 0 {
		usage(os.Stderr, scriptName)
		os.Exit(1)
	}

	var names []string
	var counts []string

	i := 0
	for i < len(args) {
		switch args[i] {
		case "--coffee", "-c":
			names = append(names, "coffee")
			counts = append(counts, args[i+1])
			i += 2
		case "--espresso", "-e":
			names = append(names, "espresso")
			counts = append(counts, args[i+1])
			i += 2
		case "--latte", "-l":
			names = append(names, "latte")
			counts = append(counts, args[i+1])
			i += 2
		case "--macchiato", "-k":
			names = append(names, "macchiato")
			counts = append(counts, args[i+1])
			i += 2
		case "--capucino", "-p":
			names = append(names, "capucino")
			counts = append(counts, args[i+1])
			i += 2
		case "--mocha", "-m":
			names = append(names, "mocha")
			counts = append(counts, args[i+1])
			i += 2
		case "--tea", "-t":
			names = append(names, "tea")
			counts = append(counts, args[i+1])
			i += 2
		case "--help", "-h", "-?":
			usage(os.Stdout, scriptName)
			os.Exit(0)
		default:
			usage(os.Stderr, scriptName)
			os.Exit(1)
		}
	}

	if len(names) == 0 {
		usage(os.Stderr, scriptName)
		os.Exit(1)
	}

	fmt.Println()
	fmt.Println("You ordered: ")
	for i, name := range names {
		n, _ := strconv.Atoi(counts[i])
		label := name
		if n != 1 {
			label += "s"
		}
		fmt.Printf("* %s %s\n", counts[i], label)
	}
}
