// testbox: title="infinite for with break"

package main

import "fmt"

func main() {
	count := 10
	for {
		if count == 0 {
			break
		}
		fmt.Println("Count is", count)
		count--
	}
}
