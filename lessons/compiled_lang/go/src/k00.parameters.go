package main

import "fmt"

func celsius(fahrenheit float64) {
	temperature := (fahrenheit - 32.0) * 5 / 9
	fmt.Printf("The Celsius temperature is %.1f degrees.\n", temperature)
}

func main() {
	temperature := 73.0
	celsius(temperature)
}
