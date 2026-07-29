// testbox: title="for ;; {} with continue"

package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)

	for ; ; {
		fmt.Print("Enter your name (quit to exit): ")
		stdin.Scan()
		answer := stdin.Text()

		if strings.TrimSpace(answer) == "" {
			continue
		}

		if answer == "quit" {
			break
		}

		fmt.Println("Hello " + answer + "!")
	}
}
