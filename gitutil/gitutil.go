package gitutil

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
)

func IsInGitignore(gitignorePath, pattern string) bool {
	file, err := os.Open(gitignorePath)
	if err != nil {
		return false
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == pattern || line == pattern+"/" || strings.Contains(line, pattern) {
			return true
		}
	}
	return false
}

func GetGitRemoteURL(repoPath string) string {
	cmd := exec.Command("git", "remote", "-v")
	cmd.Dir = repoPath
	output, err := cmd.Output()
	if err != nil {
		return ""
	}
	lines := strings.Split(string(output), "\n")
	if len(lines) > 0 {
		parts := strings.Fields(lines[0])
		if len(parts) >= 2 {
			return parts[1]
		}
	}
	return ""
}

func ExtractOwnerRepo(url string) string {
	// Remove .git suffix if present
	url = strings.TrimSuffix(url, ".git")
	// Remove protocol if present
	url = strings.TrimPrefix(url, "https://")
	url = strings.TrimPrefix(url, "http://")
	url = strings.TrimPrefix(url, "git@")
	// Replace ':' with '/' for SSH URLs
	url = strings.Replace(url, ":", "/", 1)
	parts := strings.Split(url, "/")
	if len(parts) < 2 {
		return ""
	}
	owner := parts[len(parts)-2]
	repo := parts[len(parts)-1]
	
	// Truncate long names to prevent filesystem errors
	if len(owner) > 100 {
		owner = owner[:100]
	}
	if len(repo) > 100 {
		repo = repo[:100]
	}
	
	return owner + "/" + repo
}

func AutoCommitChanges(toolDir string) {
	cmd := exec.Command("git", "status", "--porcelain")
	cmd.Dir = toolDir
	output, err := cmd.Output()
	if err != nil {
		InitGit(toolDir)
		return
	}
	if len(strings.TrimSpace(string(output))) == 0 {
		return
	}
	fmt.Println("Changes detected, committing...")
	addCmd := exec.Command("git", "add", ".")
	addCmd.Dir = toolDir
	if err := addCmd.Run(); err != nil {
		InitGit(toolDir)
		return
	}
	commitMsg := GetCommitMessage(toolDir)
	if commitMsg == "" {
		fmt.Println("Could not generate commit message, skipping commit")
		return
	}
	commitCmd := exec.Command("git", "commit", "-m", commitMsg)
	commitCmd.Dir = toolDir
	if err := commitCmd.Run(); err != nil {
		log.Printf("Error committing changes: %v", err)
		return
	}
	pushCmd := exec.Command("git", "push")
	pushCmd.Dir = toolDir
	if err := pushCmd.Run(); err != nil {
		log.Printf("Error pushing changes: %v", err)
	} else {
		fmt.Println("Successfully committed and pushed changes")
	}
}

func InitGit(toolDir string) {
	fmt.Println("Git repository not initialized. Initializing...")
	initCmd := exec.Command("git", "init")
	initCmd.Dir = toolDir
	if err := initCmd.Run(); err != nil {
		log.Printf("Error initializing git: %v", err)
		return
	}
	fmt.Println("Git repository initialized. Please configure remote and try again.")
	fmt.Print("Press Enter when you've configured the git repository...")
	bufio.NewReader(os.Stdin).ReadBytes('\n')
}

func GetCommitMessage(toolDir string) string {
	cmd := exec.Command("commit")
	cmd.Dir = toolDir
	output, err := cmd.Output()
	if err == nil && len(strings.TrimSpace(string(output))) > 0 {
		return strings.TrimSpace(string(output))
	}
	cmd = exec.Command("codeforgeai", "commit-message")
	cmd.Dir = toolDir
	output, err = cmd.Output()
	if err == nil && len(strings.TrimSpace(string(output))) > 0 {
		return strings.TrimSpace(string(output))
	}
	fmt.Println("Could not find 'commit' or 'codeforgeai' command.")
	fmt.Println("Please install the commit message generator tool or manually generate a commit message.")
	fmt.Print("Press Enter when ready to continue...")
	bufio.NewReader(os.Stdin).ReadBytes('\n')
	cmd = exec.Command("commit")
	cmd.Dir = toolDir
	output, err = cmd.Output()
	if err == nil && len(strings.TrimSpace(string(output))) > 0 {
		return strings.TrimSpace(string(output))
	}
	return "Auto-sync docx files"
}
