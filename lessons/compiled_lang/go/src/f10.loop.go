// testbox: title="classic three-clause for loop"

package main

import "fmt"

func main() {
	for count := 10; count > 0; count-- {
		fmt.Println("Count is", count)
	}
}
