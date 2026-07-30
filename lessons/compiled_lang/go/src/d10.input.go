package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	fmt.Print("Input a character: ")
	character, _, _ := bufio.NewReader(os.Stdin).ReadRune()
	fmt.Printf("You entered: >>|%c|<<.\n", character)
}
