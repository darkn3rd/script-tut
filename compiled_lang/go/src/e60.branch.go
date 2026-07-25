package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
)

func main() {
	fmt.Print("Input a character: ")
	reader := bufio.NewReader(os.Stdin)
	b, _ := reader.ReadByte()
	s := string(b)

	if regexp.MustCompile("[A-Z]").MatchString(s) {
		fmt.Println("Uppercase letter")
	} else if regexp.MustCompile("[a-z]").MatchString(s) {
		fmt.Println("Lowercase letter")
	} else if regexp.MustCompile("[0-9]").MatchString(s) {
		fmt.Println("Digit")
	} else {
		fmt.Println("Punctuation, whitespace, or other")
	}
}
