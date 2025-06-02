package sync

import (
	"crypto/sha256"
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"

	"github.com/nathfavour/docxed/gitutil"
)

func ProcessDocxFolder(docxPath, destDocxDir string) {
	fmt.Printf("Processing docx folder: %s\n", docxPath)

	gitignorePath := filepath.Join(filepath.Dir(docxPath), ".gitignore")
	if !gitutil.IsInGitignore(gitignorePath, "docx") {
		fmt.Printf("Skipping %s - not in .gitignore\n", docxPath)
		return
	}

	repoPath := filepath.Dir(docxPath)
	remoteURL := gitutil.GetGitRemoteURL(repoPath)
	if remoteURL == "" {
		fmt.Printf("Skipping %s - no git remote found\n", docxPath)
		return
	}

	ownerRepo := gitutil.ExtractOwnerRepo(remoteURL)
	if ownerRepo == "" {
		fmt.Printf("Skipping %s - could not extract owner/repo from URL\n", docxPath)
		return
	}

	destDir := filepath.Join(destDocxDir, ownerRepo)
	if err := os.MkdirAll(destDir, 0755); err != nil {
		log.Printf("Error creating destination directory %s: %v", destDir, err)
		return
	}

	SyncDocxFiles(docxPath, destDir)
}

func SyncDocxFiles(sourceDir, destDir string) {
	err := filepath.Walk(sourceDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil
		}

		if info.IsDir() {
			return nil
		}

		relPath, err := filepath.Rel(sourceDir, path)
		if err != nil {
			return nil
		}

		destPath := filepath.Join(destDir, relPath)

		// Check if path is too long (prevent filesystem errors)
		if len(destPath) > 4000 { // Leave some buffer under typical 4096 limit
			log.Printf("Skipping file with path too long: %s", path)
			return nil
		}

		destDirPath := filepath.Dir(destPath)
		if err := os.MkdirAll(destDirPath, 0755); err != nil {
			log.Printf("Error creating directory %s: %v", destDirPath, err)
			return nil
		}

		if ShouldCopyFile(path, destPath) {
			if err := CopyFile(path, destPath); err != nil {
				log.Printf("Error copying file %s to %s: %v", path, destPath, err)
			} else {
				fmt.Printf("Synced: %s -> %s\n", path, destPath)
			}
		}
		return nil
	})

	if err != nil {
		log.Printf("Error syncing files: %v", err)
	}
}

func ShouldCopyFile(src, dest string) bool {
	if _, err := os.Stat(dest); os.IsNotExist(err) {
		return true
	}
	return !FilesAreEqual(src, dest)
}

func FilesAreEqual(file1, file2 string) bool {
	hash1, err1 := GetFileHash(file1)
	hash2, err2 := GetFileHash(file2)
	if err1 != nil || err2 != nil {
		return false
	}
	return string(hash1) == string(hash2)
}

func GetFileHash(filepath string) ([]byte, error) {
	file, err := os.Open(filepath)
	if err != nil {
		return nil, err
	}
	defer file.Close()
	hash := sha256.New()
	if _, err := io.Copy(hash, file); err != nil {
		return nil, err
	}
	return hash.Sum(nil), nil
}

func CopyFile(src, dest string) error {
	sourceFile, err := os.Open(src)
	if err != nil {
		return err
	}
	defer sourceFile.Close()
	destFile, err := os.Create(dest)
	if err != nil {
		return err
	}
	defer destFile.Close()
	_, err = io.Copy(destFile, sourceFile)
	return err
}

func RemoveDuplicateDocxFiles(docxRoot string) {
	hashToPath := make(map[string]string)
	var duplicates []string
	filepath.Walk(docxRoot, func(path string, info os.FileInfo, err error) error {
		if err != nil || info.IsDir() {
			return nil
		}
		hash, err := GetFileHash(path)
		if err != nil {
			return nil
		}
		hashStr := fmt.Sprintf("%x", hash)
		if orig, exists := hashToPath[hashStr]; exists {
			if orig != path {
				duplicates = append(duplicates, path)
			}
		} else {
			hashToPath[hashStr] = path
		}
		return nil
	})
	for _, dup := range duplicates {
		os.Remove(dup)
		fmt.Printf("Removed duplicate docx file: %s\n", dup)
	}
}
