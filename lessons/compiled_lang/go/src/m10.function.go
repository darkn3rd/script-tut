package main

import (
	"fmt"
	"strings"
)

func capitalize(s string) string {
	return strings.ToUpper(s)
}

func main() {
	s := "ibm"
	fmt.Printf("The current string is: \"%s\".\n", s)

	result := capitalize(s)
	fmt.Printf("The capitalized string is: \"%s\".\n", result)
}
