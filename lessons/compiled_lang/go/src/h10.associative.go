package main

import "fmt"

func main() {
	// initialize map with key/value pairs
	ages := map[string]int{
		"bob": 34, "ed": 58, "steve": 32, "ralph": 23,
	}
	// append another set of key/value pairs into map
	more := map[string]int{"deb": 46, "kate": 19}
	for k, v := range more {
		ages[k] = v
	}

	// iterate through map by keys, print key/value pairs
	fmt.Println("The ages are: ")
	for name, age := range ages {
		fmt.Printf(" ages[%s]=%d\n", name, age)
	}
}
