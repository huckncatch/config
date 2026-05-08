# CLAUDE.md - Global Instructions

This file provides universal guidance to Claude Code across all projects.

## General Principles

- **Never assume you know how a tool or app works. Always seek documentation.** When working with any tool, library, framework, or application, consult official documentation, man pages, or help output rather than relying on assumptions or general knowledge. Tools evolve, syntax changes, and edge cases exist that may not be obvious. Use resources like `man`, `--help`, official docs, or the Context7 MCP server to verify behavior before proceeding.

## Safe Development Practices

### File Standards

- All text files must end with a newline (POSIX standard)
- Respect `.editorconfig` settings when present (indentation, line endings, trim trailing whitespace)
- Preserve existing line ending style unless project specifies otherwise
- Don't introduce trailing whitespace

### Linting & Code Quality

- Always run project linters before committing (if present): `markdownlint-cli2`, `swiftlint`, `shellcheck`
- Fix linting errors rather than suppressing them (unless well-justified)
- Respect project linting configs (`.markdownlint-cli2.jsonc`, `.swiftlint.yml`, etc.)
- If unsure about a linting rule, research it before ignoring

### Command Execution

- Commands can be run without explicit paths initially
- **If a command fails unexpectedly**, try using the explicit system path (`/usr/bin/command`, `/bin/command`)
- System binaries live in `/bin`, `/usr/bin`, `/usr/sbin`, `/sbin`
- **If explicit path fixes the issue**, document it in this file so it becomes persistent knowledge
- Reason: Homebrew installations and shell aliases can alter command behavior

### Version Control Safety

- **Never commit secrets**: API keys, passwords, tokens, credentials, private keys
- Check `git status` before and after making changes
- Respect `.gitignore` - don't force-add ignored files
- Never force push to `main`/`master` branches
- Write clear, descriptive commit messages following project conventions
- **Always present commit messages for review before executing**: Draft the commit message, show it to the user, and wait for explicit approval before running `git commit`

### Testing Discipline

- Run existing tests before making changes (establish baseline)
- Run tests after making changes: `swift test`, `xcodebuild test`, script test suites
- If tests fail, fix the issue or revert changes
- Don't skip or comment out failing tests
- Add tests for new functionality when the project has a test suite


## Markdown Linting

**Always run `markdownlint-cli2` from the project root directory** to pick up the `.markdownlint-cli2.jsonc` config file. Running from a subdirectory may not traverse far enough to find the root config.

## Memory System

Memory files live in `~/.config/claude/memory/`. A PreToolUse hook auto-injects the
global index, general rules, and current project memory once per session.

**File map:**
- `memory.md` — global index and routing table (always injected)
- `general.md` — cross-project rules always in effect (always injected)
- `tools/{tool}.md` — tool-specific knowledge, load on demand
- `~/.config/claude/projects/{path}/memory/MEMORY.md` — per-project context (always injected)

**Load on demand** (read the file when the topic comes up):
- Ghostty terminal config or commands → `~/.config/claude/memory/tools/ghostty.md`

**Adding new memory:**
- Cross-project preference or workflow rule → append to `general.md`
- Tool-specific knowledge → create or update `tools/{tool}.md`, add pointer in `memory.md`
- Project-specific context → update that project's `MEMORY.md`

## Work Process

- **TODO.md**: When starting a new session or when asked "what's next", check if the project has a TODO.md and reference it to suggest relevant tasks. Keep it current as work progresses: mark items completed (with date), update status notes, move resolved items to a Completed section, and add new items when planned work is identified.
