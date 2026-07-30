package main

import (
	"fmt"
	"strconv"
)

func main() {
	number := 5
	character := 'a'
	text := "This is a string"

	output := "Number is " + strconv.Itoa(number) + ".\n" +
		"Character is '" + string(character) + "'.\n" +
		"String is \"" + text + "\".\n"

	fmt.Print(output)
}
