package main

import "testing"

func TestMin(t *testing.T) {
	numbers := []int{48, 96, 86, 68, 57, 82, 63, 70, 37, 34, 83, 27, 19, 97, 9, 17}

	expected := 9

	result := Min(numbers)

	if result != expected {
		t.Errorf("Error. Except %d got %d", expected, result)
	}
}
