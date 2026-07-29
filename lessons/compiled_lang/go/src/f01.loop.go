// testbox: title="range over slice (index form)"

package main

import (
	"fmt"
	"os"
)

func main() {
	entries, err := os.ReadDir("dirtest")
	if err != nil {
		panic(err)
	}

	// range with only the index, indexing into the slice for the value
	for i := range entries {
		entry := entries[i]
		if entry.IsDir() {
			fmt.Println(entry.Name() + " is a directory")
		} else {
			fmt.Println(entry.Name() + " is not a directory")
		}
	}
}
