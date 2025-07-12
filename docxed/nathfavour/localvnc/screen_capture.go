package main

import (
	"fmt"
	"image/png"
	"os"

	"github.com/kbinani/screenshot"
)

func main() {
	img, err := screenshot.CaptureDisplay(0)
	if err != nil {
		fmt.Println("Screen capture failed:", err)
		return
	}
	if img == nil {
		fmt.Println("Screen capture returned nil image. This may be due to missing permissions, running under Wayland, or not having an active X11 session.")
		return
	}
	file, err := os.Create("screenshot.png")
	if err != nil {
		fmt.Println("Failed to create file:", err)
		return
	}
	defer file.Close()
	err = png.Encode(file, img)
	if err != nil {
		fmt.Println("Failed to encode PNG:", err)
		return
	}
	fmt.Println("Screenshot saved as screenshot.png")
}
