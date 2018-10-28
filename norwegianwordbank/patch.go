package main

import (
	//	"unicode/utf8"
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

func toUtf8(iso8859_1_buf []byte) string {
	buf := make([]rune, len(iso8859_1_buf))
	for i, b := range iso8859_1_buf {
		buf[i] = rune(b)
	}
	return string(buf)
}

func main() {
	file, _ := os.Open("fullform_bm.txt")
	defer file.Close()

	reader := bufio.NewReader(file)

	i := 0

	for {
		line, err := reader.ReadString('\n')

		if err != nil {
			if err == io.EOF {
				break
			}
		}

		if strings.TrimSpace(line) != "" {
			first := string(line[0:1])
			if first != "*" {
				p := strings.Split(line, "\t")

				if len(p) > 0 {
					p[1] = strings.Replace(p[1], "\n", "", 1)
					p[2] = strings.Replace(p[2], "\n", "", 1)

					fmt.Print(toUtf8([]byte(p[1])) + " " + toUtf8([]byte(p[2])) + "\n")

					i++
				}
			} else {
			}
		}
	}

	fmt.Println("Lines " + strconv.Itoa(i))
}
