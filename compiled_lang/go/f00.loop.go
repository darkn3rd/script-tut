// testbox: title="range over slice (value form)"

package main

import (
	"fmt"
	"os"
)

func main() {
	// os.ReadDir() already returns entries sorted by filename
	entries, err := os.ReadDir("dirtest")
	if err != nil {
		panic(err)
	}

	for _, entry := range entries {
		if entry.IsDir() {
			fmt.Println(entry.Name() + " is a directory")
		} else {
			fmt.Println(entry.Name() + " is not a directory")
		}
	}
}
