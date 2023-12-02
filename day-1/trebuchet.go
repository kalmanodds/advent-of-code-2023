package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"unicode"
)

// Usage: go run trebuchet.go [1 || 2]
func main() {
	part := parseArgs()
	lines := readFile("_inputs/input.txt")
	result := parseInput(lines, part)
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

func parseInput(lines []string, part int) int {
	total := 0
	for _, line := range lines {
		firstNumberNotFound := true
		firstNumber := 0
		number := 0
		for index := range line {
			if startsWithNumber(line[index:], &number, part) {
				if firstNumberNotFound {
					firstNumber = number
					firstNumberNotFound = false
				}
			}
		}
		lineNumber := firstNumber * 10 + number
		total = total + lineNumber
	}
	return total

}

func startsWithNumber(subString string, number *int, part int) bool {
	character := rune(subString[0])
	if part == 1 {
		return isNumeral(character, number)
	}
	if part == 2 {
		return isNumeral(character, number) || isNumberString(subString, number)
	}
	panic("first argument must be 1 or 2")
}

func isNumeral(character rune, number *int) bool {
	if unicode.IsDigit(character) {
		*number = int(character - '0')
		return true
	}
	return false
}

func isNumberString(subString string, number *int) bool {
	numberStrings := [9]string{
		"one",
		"two",
		"three",
		"four",
		"five",
		"six",
		"seven",
		"eight",
		"nine",
	}
	for index, numberString := range numberStrings {
		if strings.HasPrefix(subString, numberString) {
			*number = index + 1
			return true
		}
	}
	return false
}