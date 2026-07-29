package main

import (
	"bufio"
	"fmt"
	"math/rand"
	"os"
	"sort"
	"strings"
)

func main() {
	drinks := map[string]int{
		"Capucino": 0,
		"Coffee":   0,
		"Espresso": 0,
		"Latte":    0,
		"Machiato": 0,
		"Mocha":    0,
		"Tea":      0,
	}

	args := os.Args[1:]
	if len(args) == 0 {
		for key := range drinks {
			drinks[key] = rand.Intn(3)
		}
	} else {
		for _, pair := range args {
			parts := strings.SplitN(pair, ":", 2)
			key, qty := parts[0], parts[1]
			n := 0
			fmt.Sscanf(qty, "%d", &n)
			drinks[key] = n
		}
	}

	keys := make([]string, 0, len(drinks))
	for key := range drinks {
		keys = append(keys, key)
	}
	sort.Strings(keys)

	var entries []string
	for _, key := range keys {
		if qty := drinks[key]; qty != 0 {
			entries = append(entries, fmt.Sprintf("%s:%d", key, qty))
		}
	}

	os.Setenv("MY_ORDERS", strings.Join(entries, ","))

	// Dump this process's own environment (reflecting the MY_ORDERS just
	//  set above) to a well-known file for an external observer to
	//  inspect while this program is paused below - deleted again once
	//  that observer is done and this program is about to exit.
	dump, err := os.Create("dump_env.out")
	if err == nil {
		for _, entry := range os.Environ() {
			fmt.Fprintln(dump, entry)
		}
		dump.Close()
	}

	fmt.Println("MY_ORDERS set, Hit Return to continue")
	bufio.NewReader(os.Stdin).ReadString('\n')

	os.Remove("dump_env.out")
}
