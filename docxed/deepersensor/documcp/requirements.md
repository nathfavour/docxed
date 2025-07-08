# documcp: Modular Documentation Crawler, Indexer, and MCP API Server in Go

## Overview

`documcp` is a modular Go package designed to serve as a documentation crawler, smart text extractor, advanced full-text indexer, and MCP (Model Context Protocol) API server. The goal is to recursively traverse one or more documentation websites, extract and index their textual content efficiently, and expose a server interface for downstream AI or application queries.

This project will be **built from scratch** in Go, with minimal to zero third-party dependencies (only using Go's standard library and, if absolutely necessary, official Go extensions).

---

## Modules and Responsibilities

### 1. **Crawler Module**
- **Purpose:** Recursively traverses provided documentation URLs, discovering and fetching all reachable pages within the same domain(s).
- **Features:**
  - Accepts one or more seed URLs.
  - Maintains a "visited" set to prevent duplicate processing.
  - Observes robots.txt and crawl-delay if present.
  - Follows only internal links (configurable).
  - Supports concurrency with worker pools and rate-limiting.
  - Handles HTTP/HTTPS, follows redirects, retries on failures.
- **Extensibility:** Should allow easy addition of custom crawling logic (e.g., for login, pagination, etc.).

### 2. **HTML/Text Extraction Module**
- **Purpose:** Parses HTML content to extract visible, meaningful text for indexing.
- **Features:**
  - Strips scripts, styles, navigation, and boilerplate.
  - Extracts main content, section titles, and metadata.
  - Optionally supports Markdown extraction.
  - Handles character encoding, HTML entities, and malformed HTML.
  - Configurable extractors for custom document structures.
- **Extensibility:** Pluggable extraction strategies for different site templates or markup variants.

### 3. **Document Representation Module**
- **Purpose:** Defines how crawled content is structured and stored.
- **Features:**
  - Stores source URL, extracted text, title, hierarchical structure (headings/subsections), and metadata (e.g., last-modified).
  - Assigns unique IDs to documents.
  - Versioning support for changed documents.
- **Extensibility:** Future-proof for attachments, images, or code snippets.

### 4. **Indexing/Search Module**
- **Purpose:** Efficiently indexes extracted content for fast retrieval and relevance ranking.
- **Features:**
  - Custom in-memory inverted index for full-text search.
  - Tokenization, normalization, stemming (as required).
  - Scoring and ranking (BM25 or TF-IDF logic).
  - Supports phrase, boolean, and fuzzy search queries.
  - Optional disk persistence of index (simple file-based, binary or JSON).
- **Extensibility:** Pluggable ranking algorithms or additional storage backends.

### 5. **API Server (MCP Interface)**
- **Purpose:** Exposes a REST/HTTP interface for querying indexed content and managing the crawler. The API server also implements the MCP (Model Context Protocol) to communicate with AI models.
- **Features:**
  - Endpoints to:
    - Trigger new crawls (single or batch URLs).
    - Query indexed documents (search, filter, paginate).
    - Retrieve raw or formatted content by ID/URL.
    - Monitor crawler/indexer status and statistics.
  - JSON (and optionally gRPC/WebSocket) support.
  - Secure API (API key or token-based).
  - Extensible to support AI model integration (prompt/response endpoints via MCP).
- **Extensibility:** Middleware for authentication, logging, rate-limiting.

### 6. **Scheduler & Orchestrator**
- **Purpose:** Coordinates crawling, indexing, and handles periodic updates.
- **Features:**
  - Scheduled re-crawling based on interval or detected changes (ETag, Last-Modified).
  - Queue and priority system for crawl jobs.
  - Graceful shutdown, status reporting, and recovery from interruptions.
- **Extensibility:** Plug in custom scheduling logic or distributed coordination.

### 7. **Configuration & Logging Module**
- **Purpose:** Centralized configuration and detailed logging for observability.
- **Features:**
  - Configurable via file (YAML/JSON/TOML) or environment variables.
  - Log levels, structured logs, and error reporting.
  - Runtime metrics (pages/min, queue depth, memory usage).

---

## Non-Functional Requirements

- **Performance:** Able to crawl and index large documentation sites efficiently on commodity hardware.
- **Resource Usage:** Minimal dependencies; optimized for low memory and disk usage.
- **Portability:** Single binary; cross-compilation support for all major platforms.
- **Robustness:** Handles network errors, malformed documents, and large workloads gracefully.
- **Security:** Sanitize all fetched inputs, protect API endpoints.
- **Extensibility:** Modular design for future plugin support (parsers, indexers, API integrations).

---

## Example Use Cases

- Indexing open-source project documentation for internal search or AI knowledgebase.
- Powering a self-hosted "knowledge MCP" for organizations.
- Feeding LLMs or chatbots with up-to-date, structured documentation.

---

## Out of Scope (Initial Version)

- Non-HTTP sources (e.g., Git repositories, PDFs) unless trivial.
- Full browser rendering (no headless Chrome; only HTML parsing).
- Built-in AI/ML models (focus is on serving data, not generation).

---

## File/Directory Structure (Proposed)

```
documcp/
├── cmd/            # CLI entrypoint and server bootstrap
├── crawler/        # Crawler logic
├── extractor/      # HTML/text extraction
├── docstore/       # Document data structures
├── index/          # In-memory/disk indexer
├── api/            # HTTP API server
├── scheduler/      # Crawl job orchestration
├── config/         # Config and logging
├── internal/       # Shared utilities
└── README.md
```

---

## Development Notes

- All logic to be implemented in idiomatic Go, leveraging only the standard library and critical Go extensions (e.g., `golang.org/x/net/html`).
- Each module must be independently testable and reusable.
- Document all exported types and functions for easy consumption by downstream projects.

---

## Future Roadmap

- Plugin system for extractors and indexers
- Distributed or clustered crawling
- Real-time change detection
- Integration with external LLMs for semantic search

---

## Credits

Crafted as a ground-up, dependency-light, production-quality Go project focused on developer and AI integration needs.
