package main

import (
	"fmt"
	"os"
)

func main() {
	for _, entry := range os.Environ() {
		fmt.Println(entry)
	}
}
