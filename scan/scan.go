package scan

import (
	"github.com/nathfavour/docxed/sync"
	"log"
	"os"
	"path/filepath"
)

func ScanAndSync(targetPath, docxDir string) {
	err := filepath.Walk(targetPath, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil // Skip errors and continue
		}

		if info.IsDir() && info.Name() == "docx" {
			sync.ProcessDocxFolder(path, docxDir)
		}
		return nil
	})

	if err != nil {
		log.Printf("Error walking directory: %v", err)
	}
}
