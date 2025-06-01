# DocXed - Automated Documentation Synchronizer

A robust Go CLI tool that monitors and synchronizes documentation folders (`docx`) from local git repositories to a centralized location.

## Features

- **Recursive Monitoring**: Scans all subdirectories for `docx` folders
- **Git Integration**: Only processes folders that are properly ignored in `.gitignore`
- **Remote Detection**: Extracts repository information from git remotes
- **Smart Sync**: Only copies files when content differs (using SHA256 hashing)
- **Background Monitoring**: Continuously watches for changes every 30 seconds
- **Auto-commit**: Automatically commits and pushes changes to its own repository
- **Error Handling**: Graceful handling of git operations and missing dependencies

## Installation

1. Clone this repository:
   ```bash
   git clone <your-repo-url>
   cd docxed
   ```

2. Build the tool:
   ```bash
   go build -o docxed
   ```

3. (Optional) Install globally:
   ```bash
   go install
   ```

## Usage

```bash
./docxed /path/to/your/projects
```

Example:
```bash
./docxed /home/user/dev/projects
```

## How It Works

1. **Scans** the provided directory recursively for `docx` folders
2. **Validates** that each `docx` folder is listed in the local `.gitignore` file
3. **Extracts** the git remote URL to determine repository owner/name
4. **Syncs** files from the source `docx` folder to `./docx/{owner}/{repo}/`
5. **Monitors** continuously for changes and new repositories
6. **Auto-commits** changes to its own repository using external commit tools

## Directory Structure

After running, your tool directory will look like:
```
docxed/
├── main.go
├── go.mod
├── docxed (binary)
└── docx/
    ├── owner1/
    │   └── repo1/
    │       ├── file1.md
    │       └── file2.md
    └── owner2/
        └── repo2/
            └── documentation.md
```

## Prerequisites

- **Git**: Must be installed and accessible from command line
- **Commit Message Generator** (optional): 
  - `commit` command, or
  - `codeforgeai commit-message` command
  - If neither is available, the tool will use a default commit message

## Git Repository Setup

The tool expects to run in its own git repository. If not initialized:

1. The tool will automatically run `git init`
2. You'll need to configure the remote repository
3. The tool will prompt you to complete setup before continuing

## Configuration

No configuration file needed! The tool works by:

- Detecting `docx` folders in `.gitignore`
- Extracting repository info from git remotes
- Using file content comparison for intelligent syncing

## Error Handling

- **Missing Git**: Tool will attempt to initialize if needed
- **No Remote**: Skips repositories without configured remotes
- **Missing .gitignore**: Only processes folders that are properly ignored
- **File Conflicts**: Uses content hashing to determine if updates are needed

## Background Operation

Once started, the tool runs continuously:
- Scans every 30 seconds for changes
- Automatically commits and pushes its own updates
- Handles new repositories and documentation files

## Stopping the Tool

Use `Ctrl+C` to stop the background monitoring.

## Support

For issues or feature requests, please open an issue in this repository.