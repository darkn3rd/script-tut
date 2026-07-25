// testbox: title="while-style for (single condition)"

package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)
	answer := ""
	for answer != "quit" {
		fmt.Print("Enter your name (quit to Exit): ")
		stdin.Scan()
		answer = stdin.Text()

		if answer != "quit" {
			fmt.Println("Hello " + answer + "!")
		}
	}
}
