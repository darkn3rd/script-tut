package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	fmt.Print("Select an item from the menu.\n\n" +
		"  1 - Coffee\n" +
		"  2 - Espresso\n" +
		"  3 - Latte\n" +
		"  4 - Machiato\n" +
		"  5 - Capucino\n" +
		"  6 - Mocha\n" +
		"  7 - Tea\n\n" +
		"Make your selection: ")

	reader := bufio.NewReader(os.Stdin)
	b, _ := reader.ReadByte()
	selection := int(b) - int('0')

	if selection == 1 {
		fmt.Println("You selected a Coffee")
	} else if selection == 2 {
		fmt.Println("You selected an Espresso")
	} else if selection == 3 {
		fmt.Println("You selected a Latte")
	} else if selection == 4 {
		fmt.Println("You selected a Machiato")
	} else if selection == 5 {
		fmt.Println("You selected a Capucino")
	} else if selection == 6 {
		fmt.Println("You selected a Mocha")
	} else if selection == 7 {
		fmt.Println("You selected a Tea")
	} else {
		fmt.Println("You have not entered a valid selection")
	}
}
