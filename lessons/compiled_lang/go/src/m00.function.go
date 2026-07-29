package main

import "fmt"

func addNums(numbers ...int) int {
	sum := 0
	for _, num := range numbers {
		sum += num
	}
	return sum
}

func main() {
	fmt.Println("The numbers to be added are 5, 2, 4, 3, 6.")

	result := addNums(5, 2, 4, 3, 6)
	fmt.Printf("The result of their summation is: %d.\n", result)
}
