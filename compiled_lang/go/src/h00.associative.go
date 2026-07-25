package main

import (
	"fmt"
	"strings"
)

func main() {
	// create empty map
	ages := make(map[string]int)
	// insert one element at a time
	ages["bob"] = 34
	ages["ed"] = 58
	ages["steve"] = 32
	ages["ralph"] = 23
	ages["deb"] = 46
	ages["kate"] = 19

	// enumerate and print keys and values
	keys := make([]string, 0, len(ages))
	values := make([]string, 0, len(ages))
	for k, v := range ages {
		keys = append(keys, k)
		values = append(values, fmt.Sprintf("%d", v))
	}
	fmt.Println("Keys (names):  " + strings.Join(keys, ", "))
	fmt.Println("Values (ages): " + strings.Join(values, ", "))
}
