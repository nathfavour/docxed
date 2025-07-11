# LocalVNC: Screen Streaming CLI Tool

LocalVNC is a simple, modular Go CLI tool that streams your computer screen to `localhost:3456` and your local network. It works with a single command and prints a QR code for easy access.

## How It Works

1. **Screen Capture**: The tool captures the current display using a cross-platform library.
2. **HTTP Streaming**: Captured images are streamed as MJPEG over HTTP, accessible from any device on the local network.
3. **QR Code**: On startup, the tool prints a QR code containing the stream URL, which can be scanned by mobile devices for quick access.
4. **Single Command**: Running the CLI starts the server and begins streaming immediately.

## Usage

Run the CLI tool:
```
localvnc
```
Scan the QR code or open the printed URL in a browser to view the live screen stream.

## Modules

- `screen`: Handles screen capture.
- `server`: Streams images over HTTP.
- `qrcode`: Generates and prints the QR code for the stream URL.

