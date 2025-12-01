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

### Testing Discipline

- Run existing tests before making changes (establish baseline)
- Run tests after making changes: `swift test`, `xcodebuild test`, script test suites
- If tests fail, fix the issue or revert changes
- Don't skip or comment out failing tests
- Add tests for new functionality when the project has a test suite

### Safe Code Changes

- Always read files before editing them (understand context)
- Make minimal, focused changes - avoid scope creep
- Don't refactor code unless explicitly requested
- Preserve existing patterns and conventions
- When in doubt, ask rather than assume

### Build Verification

- Ensure the project builds successfully after changes
- Run build commands: `xcodebuild`, `swift build`, `make`, or project-specific commands
- Test script execution, check syntax with `bash -n` or `zsh -n`
- Don't leave the project in a broken state
- If build fails, fix it before committing

### Dependency Management

- Don't add new dependencies without considering simpler alternatives
- Respect the project's package manager (Swift Package Manager, Homebrew, etc.)
- Prefer stable, well-maintained packages
- Document why non-obvious dependencies were added

### Documentation

- Update documentation when changing behavior
- Keep README accurate with actual functionality
- For markdown projects, maintain consistent formatting
- Document non-obvious decisions or workarounds
- Update comments when changing related code

### Project Conventions

- Follow existing code style (indentation, naming, structure)
- Use the project's preferred tools and patterns
- Match existing file organization
- Don't impose personal preferences over project standards

### Security

- Don't introduce vulnerabilities (command injection, path traversal, XSS, SQL injection)
- Validate input at system boundaries
- Don't disable security features without understanding implications
- Be cautious with `eval`, `exec`, shell commands with user input
- For Swift: Avoid force-unwrapping without clear safety justification

## Markdown Linting

**Always run `markdownlint-cli2` from the project root directory** to ensure it picks up the `.markdownlint-cli2.jsonc` configuration file.

**Correct usage:**

```bash
# Run from project root (where .markdownlint-cli2.jsonc exists)
cd /path/to/project/root
markdownlint-cli2 "path/to/file.md"

# NOT from subdirectory (config might not be found)
cd /path/to/project/root/subdirectory
markdownlint-cli2 "file.md"  # ❌ Wrong - may not use config
```

**Why this matters:**

- markdownlint-cli2 searches for config files starting from the current directory and walking up the tree
- Running from a deep subdirectory may not traverse far enough to find the root config
- This ensures consistent linting rules across all markdown files in the project

## Work Process

- **After completing work**: Validate whether the project's CLAUDE.md needs updates for architecture changes, new patterns, or updated file structure. Consider if any universal workflows or cross-project preferences discovered should be added to this global CLAUDE.md. Ensure information isn't duplicated between files.
- **Check TODO.md**: When starting a new session or when asked "what's next", check if the project has a TODO.md file and reference it to suggest relevant tasks.

## Known Command Path Issues

*This section documents commands that require explicit paths due to Homebrew/alias conflicts. Add entries as they're discovered.*

<!-- Example format:
- **`grep`**: Use `/usr/bin/grep` - Homebrew version has different default options
-->
