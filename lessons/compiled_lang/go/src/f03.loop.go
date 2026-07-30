// testbox: title="range-over-func custom iterator (iter.Seq, Go 1.23+)"

package main

import (
	"fmt"
	"iter"
	"os"
)

// items returns a range-over-func iterator that yields one directory
//  entry at a time
func items(dir string) iter.Seq[os.DirEntry] {
	return func(yield func(os.DirEntry) bool) {
		entries, err := os.ReadDir(dir)
		if err != nil {
			panic(err)
		}
		for _, entry := range entries {
			if !yield(entry) {
				return
			}
		}
	}
}

func main() {
	for entry := range items("dirtest") {
		if entry.IsDir() {
			fmt.Println(entry.Name() + " is a directory")
		} else {
			fmt.Println(entry.Name() + " is not a directory")
		}
	}
}
