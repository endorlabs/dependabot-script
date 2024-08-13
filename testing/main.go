package main

import (
	"fmt"
	"os/exec"
)

func main() {
	cmd := exec.Command("bundle", "exec", "ruby", "./generic-update-script.rb")
	output, err := cmd.CombinedOutput()
	if err != nil {
		fmt.Printf("Error executing script: %v\n", err)
		return
	}
	fmt.Printf("Output: %s\n", output)
}
