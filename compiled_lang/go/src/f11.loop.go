// testbox: title="while-style for (single condition)"

package main

import "fmt"

func main() {
	count := 10
	for count > 0 {
		fmt.Println("Count is", count)
		count--
	}
}
