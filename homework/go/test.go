package main

import (
	"fmt"
)

func main() {
	arr := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}
	min := arr[0]
	for _, element := range arr {
		if element < min {
			min = element
		}
	}
	fmt.Println(min)
}
