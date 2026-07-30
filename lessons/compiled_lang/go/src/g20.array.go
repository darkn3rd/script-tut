package main

import "fmt"

func main() {
	nicknames := []string{"bob", "ed", "steve", "ralph", "joe", "deb", "kate"}

	fmt.Println("The names are: ")
	for i, name := range nicknames {
		fmt.Printf(" nicknames[%d]=%s\n", i, name)
	}
}
