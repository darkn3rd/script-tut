// testbox: title="three-clause for as conditional loop"

package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)

	// three-clause for with an empty post clause - answer is reassigned
	//  in the body instead
	for answer := ""; answer != "quit"; {
		fmt.Print("Enter your name (quit to Exit): ")
		stdin.Scan()
		answer = stdin.Text()

		if answer != "quit" {
			fmt.Println("Hello " + answer + "!")
		}
	}
}
