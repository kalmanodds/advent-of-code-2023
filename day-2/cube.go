package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	part := parseArgs()
	lines := readFile("input.txt")
	result := parseLines(lines, part)
	fmt.Println(result)
}

func parseArgs() int {
	partArg := os.Args[1]
	part, err := strconv.Atoi(partArg)
	if err != nil || part != 1 && part != 2 {
		panic("first argument must be 1 or 2")
	}
	return part
}

func readFile(fileName string) []string {
	inputBytes, err := os.ReadFile(fileName)
	if err != nil {
		panic(err)
	}
	inputString := string(inputBytes)
	lines := strings.Split(inputString, "\n")

	return lines
}

func parseLines(lines []string, part int) int {
	limit := [3]int{ 12, 13, 14 }
	total := 0
	for index, line := range lines {
		body := strings.Split(line, ": ")[1]
		sets := strings.Split(body, "; ")
		highest := getHighestFromSets(sets)
		total += getResultFromHighest(index, highest, limit, part)
	}
	return total
}

func getHighestFromSets(sets []string) [3]int {
	colors := [3]string{ "red", "green", "blue" }
	highest := [3]int{ 0, 0, 0 }
	for _, set := range sets {
		cubeCounts := strings.Split(set, ", ")
		for _, cubeCount := range cubeCounts {
			for colorIndex, color := range colors {
				if strings.Contains(cubeCount, color) {
					numberString := strings.Split(cubeCount, " ")[0]
					number, _ := strconv.Atoi(numberString)
					if highest[colorIndex] < number {
						highest[colorIndex] = number
					}
				}
			}
		}
	}
	return highest
}

func getResultFromHighest(index int, highest [3]int, limit[3]int, part int) int {
	if part == 1 {
		if isHighestWithinLimit(highest, limit) {
			return index + 1
		}
		return 0
	}
	if part == 2 {
		return highest[0] * highest[1] * highest[2]
	}
	panic("first argument must be 1 or 2")
}

func isHighestWithinLimit(highest [3]int, limit[3]int) bool {
	for index := range highest {
		if limit[index] < highest[index] {
			return false
		}
	}
	return true
}
