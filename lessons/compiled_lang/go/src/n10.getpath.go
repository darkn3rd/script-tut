package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	dirs := strings.Split(os.Getenv("PATH"), string(os.PathListSeparator))
	for _, dir := range dirs {
		fmt.Println(dir)
	}
}
