// testbox: title="for ;; {} with break"

package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)

	// the explicit empty three-clause spelling - semantically identical
	//  to bare "for {}", just written the C-style way
	for ; ; {
		fmt.Print("Enter your name (quit to exit): ")
		stdin.Scan()
		answer := stdin.Text()

		if answer == "quit" {
			break
		}

		fmt.Println("Hello " + answer + "!")
	}
}
