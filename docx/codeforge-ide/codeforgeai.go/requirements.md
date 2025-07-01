# CodeforgeAI: System Requirements and Architecture

This document describes the architecture, initialization, configuration, command-line interface, core logic, integrations, and operational flow of CodeforgeAI. It is intended to serve as a blueprint for reimplementing the tool in another language or environment.

---

## 1. Overview

CodeforgeAI is a modular, extensible AI-powered CLI tool for code analysis, editing, suggestion, and integration with external AI and blockchain services. It is designed to be developer-friendly, easily configurable, and extensible with new integrations.

---

## 2. Initialization and Configuration

### 2.1. Configuration File

- **Location:** `~/.codeforgeai.json`
- **Purpose:** Stores model names, prompt templates, and operational parameters.
- **Initialization:** On first run or if missing, a default config is created with sensible defaults for all prompts and models.
- **Config Management:** 
  - `create_default_config(config_path)` creates the config file.
  - `load_config(config_path)` always reads the latest config from disk.
  - `ensure_config_prompts(config_path)` ensures all required keys exist, updating the config if needed.

### 2.2. Config Structure

- `general_model`, `code_model`: Names of the AI models to use.
- Prompt templates for various operations (e.g., `edit_finetune_prompt`, `commit_message_prompt`).
- Formatting and operational parameters (e.g., `format_line_separator`, `debug`).

---

## 3. Command-Line Interface (CLI)

### 3.1. CLI Parsing

- **Parser:** Uses `argparse` to define a hierarchical CLI with subcommands and sub-subcommands.
- **Entry Point:** The main entry point is via `python -m codeforgeai.skeleton` or a console script.
- **Subcommands:** Each subcommand maps to a specific functionality or integration.

### 3.2. Core Subcommands

- `analyze`: Analyze the current directory, classify files, and update `.codeforge.json`.
- `prompt`: Process a user prompt, finetune it, and get a code solution.
- `edit`: Edit files or directories according to a user prompt, respecting `.gitignore`.
- `suggestion`: Provide code suggestions for a file, line, or snippet.
- `commit-message`: Generate a commit message with a relevant gitmoji.
- `explain`: Explain code in a given file.
- `strip`: Print the directory tree after removing gitignored files.
- `config`: Check and display the current configuration.

### 3.3. Integration Subcommands

- `secret-ai`: Integrate with Secret AI SDK (list models, test connection, chat).
- `web3`: Web3 development tools (scaffold project, analyze contract, estimate gas, generate tests, check/install dependencies).
- `zerepy`: ZerePy agent integration (status, list/load agents, actions, chat).
- `solana`: Solana blockchain/MCP integration (status, balance, transfer, MCP actions).
- `github copilot`: GitHub Copilot integration (login, logout, status, completions).

---

## 4. Core Logic and Flow

### 4.1. Engine

- **Purpose:** Central orchestrator for all operations.
- **Responsibilities:**
  - Loads fresh config for every operation.
  - Initializes AI models with config values.
  - Provides methods for analysis, prompt processing, code explanation, commit message generation, etc.

### 4.2. Models

- **GeneralModel:** Handles general-purpose AI requests (e.g., prompt finetuning).
- **CodeModel:** Handles code-specific AI requests (e.g., code generation, suggestions).
- **Model Selection:** Model names are dynamically loaded from config, allowing easy switching.

### 4.3. Directory and File Management

- **Directory Analysis:** Uses `tree` command to get directory structure, filters out gitignored files, and classifies files.
- **File Editing:** Gathers files (respecting `.gitignore`), applies AI-generated edits, and writes results to `.codeforgedit` files.
- **Suggestion:** Can operate on entire files, specific lines, or user-provided snippets.

### 4.4. Utilities

- **JSON Pretty Print:** For debugging and output formatting.
- **Web3 Environment Check:** Verifies presence of required tools (node, npm, truffle, etc.).
- **Dependency Installation:** Installs web3 dependencies via npm.

---

## 5. Integrations

### 5.1. Secret AI SDK

- **Purpose:** Advanced AI model integration for smart contract analysis and chat.
- **Commands:** List models, test connection, chat.
- **Credential Management:** Checks for required API keys in environment variables.

### 5.2. Web3 Tools

- **Purpose:** Scaffold, analyze, and test smart contracts and dapps.
- **Commands:** Scaffold project, analyze contract, estimate gas, generate tests, check/install dependencies.

### 5.3. ZerePy

- **Purpose:** Agent-based automation and chat.
- **Commands:** Status, list/load agents, perform actions, chat.

### 5.4. Solana MCP

- **Purpose:** Solana blockchain and MCP program interaction.
- **Commands:** Status, balance, transfer, MCP interact/state/init-account.

### 5.5. GitHub Copilot

- **Purpose:** Inline and panel code completions, authentication, and status.
- **Commands:** Login, logout, status, install LSP, inline/panel completions.

---

## 6. Operational Flow

### 6.1. CLI Entry

1. **Parse Arguments:** CLI arguments are parsed and mapped to subcommands.
2. **Setup Logging:** Logging is configured based on verbosity flags.
3. **Config Loading:** Config is loaded or initialized as needed.
4. **Command Dispatch:** The appropriate handler is called for the subcommand.

### 6.2. Command Execution

- **Analysis:** Directory is scanned, files are classified, and metadata is collected.
- **Prompt Processing:** User prompt is finetuned, then passed to the code model for a solution.
- **Editing:** Files are gathered, edited via AI, and results are saved.
- **Suggestions:** Suggestions are generated for code snippets, lines, or files.
- **Integrations:** External integrations are invoked as per subcommand, with results displayed or written to files.

---

## 7. Extensibility

- **Adding Integrations:** New integrations can be added by defining new subcommands and handler functions, and implementing the required logic in separate modules.
- **Configurable Prompts:** All prompt templates and model names are configurable via the config file.
- **Modular Design:** Each major functionality is encapsulated in its own module/class for easy replacement or extension.

---

## 8. Error Handling and Debugging

- **Logging:** All operations are logged at appropriate levels (DEBUG/INFO/WARNING/ERROR).
- **Graceful Fallbacks:** If config or models are missing, defaults are used and errors are reported.
- **User Feedback:** Errors and status messages are printed to the console for user awareness.

---

## 9. Replication Guidelines

To replicate CodeforgeAI in another language:

1. **Implement a config management system** that loads, saves, and ensures required keys in a user config file.
2. **Design a CLI parser** that supports hierarchical subcommands and options as described above.
3. **Implement core logic modules** for directory analysis, file editing, code suggestion, and commit message generation.
4. **Integrate with AI models** (local or remote) for general and code-specific tasks, using model names and prompts from config.
5. **Implement file and directory utilities** for tree parsing, gitignore filtering, and file operations.
6. **Add integration modules** for external services (AI SDKs, blockchain, Copilot, etc.), each with their own subcommands and handlers.
7. **Ensure extensibility** by keeping modules decoupled and using config-driven design.
8. **Provide robust error handling and logging** for all operations.

---

## 10. File/Module Structure

- `skeleton.py`: Main CLI entry point and command dispatcher.
- `cli.py`: Alternative CLI entry point using the parser module.
- `parser.py`: CLI argument parsing logic.
- `engine.py`: Core logic and orchestration.
- `models/`: AI model wrappers.
- `directory.py`: Directory and file analysis utilities.
- `file_manager.py`: File change application logic.
- `config.py`: Config management.
- `utils.py`: Utility functions for formatting, environment checks, etc.
- `integrations/`: External integration modules (Secret AI, Web3, ZerePy, Solana, Copilot).
- `docx/requirements.md`: This requirements and architecture document.

---

## 11. Environment and Dependencies

- **Python 3.8+**
- **Ollama** (for local AI models)
- **Node.js & npm** (for web3 tools)
- **Git** (for commit message and repo info)
- **tree** (for directory structure parsing)
- **External SDKs** as required by integrations

---

## 12. Security and Credentials

- **API Keys:** Stored in environment variables (e.g., `CLAIVE_AI_API_KEY` for Secret AI).
- **Sensitive Operations:** All external calls and file writes are handled with error checks and user feedback.

---

## 13. Testing and Validation

- **Unit Tests:** Should be written for each module.
- **Integration Tests:** For CLI commands and external integrations.
- **Manual Testing:** For new integrations and config changes.

---

*This document is intended to be a living specification. Update as new features or integrations are added.*

