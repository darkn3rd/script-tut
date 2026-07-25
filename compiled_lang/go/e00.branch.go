package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)
	fmt.Print("Would you like a toast? [Yes/No]: ")
	stdin.Scan()
	response := stdin.Text()

	var message string
	if response == "Yes" {
		message = "That's great!"
	} else {
		message = "How about a muffin?"
	}

	fmt.Println(message)
}
