package main

import "fmt"

func main() {
	nicknames := []string{"bob", "ed", "steve", "ralph", "joe", "deb", "kate"}

	fmt.Println("The names are: ")
	for _, name := range nicknames {
		fmt.Println("  " + name)
	}
}
