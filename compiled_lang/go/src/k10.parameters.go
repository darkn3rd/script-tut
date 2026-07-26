package main

import "fmt"

func addNums(numbers ...int) {
	sum := 0
	for _, num := range numbers {
		sum += num
	}
	fmt.Printf("The summation is: %d.\n", sum)
}

func main() {
	fmt.Println("Sending: 5, 2, 4, 3, 6")
	addNums(5, 2, 4, 3, 6)
}
