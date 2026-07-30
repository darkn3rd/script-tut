package main

import "fmt"

func main() {
	result := true && false || true

	fmt.Println("The statement (true AND false OR true) is:", result)
}
