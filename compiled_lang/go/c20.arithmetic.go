package main

import (
	"fmt"
	"math"
)

func main() {
	radius := 3
	area := math.Pi * math.Pow(float64(radius), 2)

	fmt.Printf("The area of a circle (radius=%d) is: %v.\n", radius, area)
}
