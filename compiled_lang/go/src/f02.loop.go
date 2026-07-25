// testbox: title="classic three-clause for loop"

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

	for i := 0; i < len(entries); i++ {
		entry := entries[i]
		if entry.IsDir() {
			fmt.Println(entry.Name() + " is a directory")
		} else {
			fmt.Println(entry.Name() + " is not a directory")
		}
	}
}
