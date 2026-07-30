package main

import (
	"fmt"
	"sort"
	"strings"
)

func sortArray(array []string) []string {
	result := make([]string, len(array))
	copy(result, array)
	sort.Strings(result)
	return result
}

func main() {
	array := []string{"bob", "ed", "steve", "ralph", "joe", "deb", "kate"}
	fmt.Println("Current names are: " + strings.Join(array, ", "))

	result := sortArray(array)
	fmt.Println("Sorted names are: " + strings.Join(result, ", "))
}
