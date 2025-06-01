.PHONY: build clean install run test help

# Build the binary
build:
	go build -o docxed main.go

# Clean build artifacts
clean:
	rm -f docxed
	go clean

# Install the binary globally
install: build
	go install

# Run the tool with a default path (change as needed)
run: build
	./docxed .

# Run tests
test:
	go test -v ./...

# Format code
fmt:
	go fmt ./...

# Run linter
lint:
	golangci-lint run

# Build for multiple platforms
build-all:
	GOOS=linux GOARCH=amd64 go build -o docxed-linux-amd64 main.go
	GOOS=darwin GOARCH=amd64 go build -o docxed-darwin-amd64 main.go
	GOOS=windows GOARCH=amd64 go build -o docxed-windows-amd64.exe main.go

# Show help
help:
	@echo "Available targets:"
	@echo "  build      - Build the binary"
	@echo "  clean      - Clean build artifacts"
	@echo "  install    - Install binary globally"
	@echo "  run        - Build and run with current directory"
	@echo "  test       - Run tests"
	@echo "  fmt        - Format code"
	@echo "  lint       - Run linter"
	@echo "  build-all  - Build for multiple platforms"
	@echo "  help       - Show this help message"