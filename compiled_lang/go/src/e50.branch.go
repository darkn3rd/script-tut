package main

import (
	"bufio"
	"fmt"
	"os"
	"unicode"
)

func main() {
	fmt.Print("Input a character: ")
	reader := bufio.NewReader(os.Stdin)
	b, _ := reader.ReadByte()
	keypress := rune(b)

	// a tagless switch - each case is its own boolean expression, Go's
	//  idiomatic stand-in for a pattern-matching multiway branch
	switch {
	case unicode.IsUpper(keypress):
		fmt.Println("Uppercase letter")
	case unicode.IsLower(keypress):
		fmt.Println("Lowercase letter")
	case unicode.IsDigit(keypress):
		fmt.Println("Digit")
	default:
		fmt.Println("Punctuation, whitespace, or other")
	}
}
