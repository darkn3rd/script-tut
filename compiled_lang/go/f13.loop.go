// testbox: title="range-over-int (Go 1.22+)"

package main

import "fmt"

func main() {
	// range-over-int counts 0..9; map it back to 10..1
	for i := range 10 {
		fmt.Println("Count is", 10-i)
	}
}
