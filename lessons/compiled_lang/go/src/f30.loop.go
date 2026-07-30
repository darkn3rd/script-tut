// testbox: title="bare for {} with break"

package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)
	for {
		fmt.Print("Enter your name (quit to exit): ")
		stdin.Scan()
		answer := stdin.Text()

		if answer == "quit" {
			break
		}

		fmt.Println("Hello " + answer + "!")
	}
}
