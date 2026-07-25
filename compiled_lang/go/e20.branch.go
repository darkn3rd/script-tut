package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	stdin := bufio.NewScanner(os.Stdin)
	fmt.Print("Input a number: ")
	stdin.Scan()
	number, _ := strconv.Atoi(stdin.Text())

	if number > 0 {
		fmt.Println("Number is greater than 0")
	} else if number < 0 {
		fmt.Println("Number is less than 0")
	} else {
		fmt.Println("Number is 0")
	}
}
