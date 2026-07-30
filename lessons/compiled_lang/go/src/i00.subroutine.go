package main

import (
	"fmt"
	"time"
)

func showDate() {
	fmt.Println("Today is " + time.Now().Format("January 2, 2006") + ".")
}

func main() {
	showDate()
}
