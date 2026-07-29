package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)
	fmt.Print("Enter your name: ")
	stdin.Scan()
	name := stdin.Text()
	fmt.Printf("Hello %s!\n", name)
}
