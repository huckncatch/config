# CLAUDE.md - Global Instructions

This file provides universal guidance to Claude Code across all projects.

## Behavioral Foundation

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don’t assume. Don’t hide confusion. Surface tradeoffs.**

- State assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them — don’t pick silently.
- If something is unclear, stop. Name what’s confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked. No abstractions for single-use code.
- No error handling for impossible scenarios.
- Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

- Don’t improve adjacent code, comments, or formatting.
- Match existing style, even if you’d do it differently.
- Remove imports/variables YOUR changes made unused. Don’t remove pre-existing dead code.
- Test: every changed line must trace directly to the request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

- Transform tasks into verifiable goals: "Fix the bug" → "Write a test that reproduces it, then make it pass"
- For multi-step tasks: `1. [Step] → verify: [check]`
- Strong success criteria let you loop independently. Weak criteria require constant clarification.

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
- Always run `markdownlint-cli2` from the **project root** (not a subdirectory) — config lookup starts from cwd

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
- Run tests after making changes per project convention
- If tests fail, fix the issue or revert changes
- Don't skip or comment out failing tests
- Add tests for new functionality when the project has a test suite

## Memory System

### Where to save

| What | Where |
|---|---|
| Cross-project behavior corrections or preferences | `~/.config/claude/memory/general.md` |
| Tool-specific knowledge (CLI syntax, quirks, workarounds) | `~/.config/claude/memory/tools/{tool}.md` (add pointer in `memory.md`) |
| Project-specific context, decisions, ongoing work | Project `MEMORY.md` (`~/.config/claude/projects/{path}/memory/MEMORY.md`) |

### Global vs. project: the deciding question

**Ask:** "If I opened a completely different project tomorrow, would this correction or fact still apply?"

- **Yes → global** (`general.md` or `tools/`): behavioral corrections, tool usage patterns, communication preferences, git workflow rules. These apply regardless of which project is open.
- **No → project** (`MEMORY.md`): codebase-specific conventions, decisions made for this repo, ongoing work context, architecture notes.

A feedback memory about *how* to use a tool (e.g. "don't use `git -C` when already in cwd") is global. A feedback memory about *this project's* code patterns is project-specific.

When in doubt, ask: would a colleague need to know this rule on a completely different codebase? If yes, it's global.

### Loading

Load `tools/ghostty.md` for Ghostty questions. Load `tools/obsidian.md` for any Obsidian search or note operation.

## Work Process

- **After completing work**: Validate whether the project's CLAUDE.md needs updates for architecture changes, new patterns, or updated file structure. Consider if any universal workflows or cross-project preferences discovered should be added to this global CLAUDE.md. Ensure information isn't duplicated between files.
- **TODO.md**: When starting a new session or when asked "what's next", check if the project has a TODO.md and reference it to suggest relevant tasks. Keep it current as work progresses: mark items completed (with date), update status notes, move resolved items to a Completed section, and add new items when planned work is identified.

## Cross-Project Knowledge Base

The Obsidian vault at `/Users/soob/Dropbox/Apps/Obsidian` (`Home/` sub-vault) is the shared "second brain" for all Claude Code projects — accessible everywhere via the global `obsidian-cortex` MCP server.

Every project's CLAUDE.md should include a "Cross-repo documentation (Obsidian)" section pointing to its project note in the vault — except the Obsidian vault project itself, which documents this role directly in its own CLAUDE.md.

If a project's CLAUDE.md is missing this section, add it: see the `second-brain` skill for templates and conventions, or run `/vault-init` to bootstrap a new project.

## Known Command Path Issues

**Prefer `command <cmd>` over bare invocations** to bypass shell functions, aliases, and zsh hooks that could produce output differences or unexpected behavior. For example, use `command grep` instead of `grep`. Fall back to explicit system paths (`/usr/bin/grep`) only when `command` doesn't resolve the issue.

*This section documents commands that require explicit paths due to Homebrew/alias conflicts. Add entries as they're discovered.*
