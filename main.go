package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/nathfavour/docxed/gitutil"
	"github.com/nathfavour/docxed/scan"
	"github.com/nathfavour/docxed/sync"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: docxed <folder_path>")
		fmt.Println("Example: docxed /path/to/projects")
		os.Exit(1)
	}

	targetPath := os.Args[1]
	absPath, err := filepath.Abs(targetPath)
	if err != nil {
		log.Fatal("Error resolving path:", err)
	}
	fmt.Printf("Starting docx monitoring for: %s\n", absPath)

	toolDir, err := os.Getwd()
	if err != nil {
		log.Fatal("Error getting current directory:", err)
	}
	docxDir := filepath.Join(toolDir, "docx")
	if err := os.MkdirAll(docxDir, 0755); err != nil {
		log.Fatal("Error creating docx directory:", err)
	}
	fmt.Println("Performing initial scan...")
	scan.ScanAndSync(absPath, docxDir)
	fmt.Println("Starting background monitoring...")
	ticker := time.NewTicker(30 * time.Second)
	defer ticker.Stop()
	for {
		select {
		case <-ticker.C:
			scan.ScanAndSync(absPath, docxDir)
			sync.RemoveDuplicateDocxFiles(docxDir)
			gitutil.AutoCommitChanges(toolDir)
		}
	}
}
