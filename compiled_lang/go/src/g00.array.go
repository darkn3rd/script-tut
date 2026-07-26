package main

import (
	"fmt"
	"strings"
)

func main() {
	// populate array one item at a time
	var nicknames [7]string
	nicknames[0] = "bob"
	nicknames[1] = "ed"
	nicknames[2] = "steve"
	nicknames[3] = "ralph"
	nicknames[4] = "joe"
	nicknames[5] = "deb"
	nicknames[6] = "kate"

	fmt.Println("The total nicknames are:", len(nicknames))
	fmt.Println("The nicknames are: " + strings.Join(nicknames[:], ", "))
}
