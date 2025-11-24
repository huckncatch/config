# TODO

Future improvements and features for this configuration repository.

## Planned Work

### Fix Markdownlint Errors in Project Files

Run `markdownlint-cli2 "**/*.md"` and fix all errors in project-owned markdown files.

**Files with errors:**

- MODERN_CLI_TOOLS.md (48 errors) - table styles, bare URLs, heading punctuation, blank lines
- NOTES.md (4 errors) - blank lines around code blocks, heading increment
- TODO.md (11 errors) - blank lines around lists and code blocks

**Action items:**

- Fix MODERN_CLI_TOOLS.md errors
- Fix NOTES.md errors
- Fix TODO.md errors
- Verify zero errors with `markdownlint-cli2 "**/*.md"`
- Status: Not started

### Review Oh-My-Zsh Plugins for Useful Additions

Review the built-in oh-my-zsh plugins to identify useful ones not currently enabled.

**Current plugins enabled:**
- zsh-nvm
- profiles
- alias-finder
- bbedit
- brew
- git
- gitfast
- git-prompt
- iterm2
- npm
- sudo
- tmux
- vscode
- zsh-autosuggestions
- fast-syntax-highlighting

**Action items:**
- Browse oh-my-zsh plugins directory or documentation
- Identify plugins that would improve workflow
- Test selected plugins in local profile
- Update profile templates if plugins should be enabled by default
- Document any plugin-specific configuration needed
- Status: Not started

### Resolve Homebrew Node vs zsh-nvm Conflict

Resolution: Keep both installations - they coexist without real conflict.

Investigation revealed:
- In interactive shells, zsh-nvm plugin ensures nvm's Node takes precedence
- markdownlint-cli2 Homebrew formula has hardcoded shebang (`#!/opt/homebrew/opt/node/bin/node`)
- Cannot use nvm's Node with Homebrew's markdownlint-cli2 due to shebang hardcoding
- Both Node installations can coexist peacefully

Decision: Keep both Homebrew Node (for markdownlint-cli2) and nvm (for project development).

- Status: Resolved

### Monitor Claude Code XDG Base Directory Compliance

Periodically check if Claude Code has improved its XDG Base Directory specification support.

**Current State (as of 2025-10-23):**

Configuration directory resolution order:
1. `$CLAUDE_CONFIG_DIR` (if set) - highest priority
2. `$XDG_CONFIG_HOME/claude` (if XDG_CONFIG_HOME is set)
3. `~/.claude` (default fallback)

Known issues with XDG compliance:
- **Partial XDG support**: Claude Code uses `$XDG_CONFIG_HOME/claude` but violates XDG spec by placing ALL files there (config, cache, state, runtime data)
- **Per XDG spec**: Only config files (CLAUDE.md, commands/, settings.json) should be in `$XDG_CONFIG_HOME/claude/`
- **Should use**: `$XDG_DATA_HOME`, `$XDG_STATE_HOME`, `$XDG_CACHE_HOME` for non-config data (local/, projects/, statsig/, todos/)
- **CLAUDE_CONFIG_DIR bugs**: Still creates local `.claude/` directories even when CLAUDE_CONFIG_DIR is set (Issue #3833)
- **Installation detection**: Ignores CLAUDE_CONFIG_DIR when detecting local installations (Issue #2986)

Related GitHub issues:
- #1455: Does not respect XDG Base Directory specification
- #2350: Move runtime/cache files out of $XDG_CONFIG_HOME
- #2277: Docs about `~/.claude` contradict actual CLI behavior
- #3833: CLAUDE_CONFIG_DIR behavior unclear - still creates local directories
- #2986: Local installation detection ignores CLAUDE_CONFIG_DIR

**Action items:**
- Periodically check if issues #1455, #2350, #3833, #2986 are resolved
- Review Claude Code release notes for XDG-related improvements
- Test if `$XDG_DATA_HOME`, `$XDG_STATE_HOME`, `$XDG_CACHE_HOME` become supported
- Update repository configuration if Claude Code achieves full XDG compliance
- Status: Monitoring (check quarterly or when major Claude Code versions release)

## Ideas / Future Consideration

Items that need more thought or may not be implemented

- None currently

## Completed

### Consolidate Profile Systems

**Status:** Completed 2025-10-25

Unified the two profile systems into a complementary dual-profile architecture:

**Solution implemented:**
- **Profile templates** (`profile-home.zsh`/`profile-work.zsh`) define theme and plugins before oh-my-zsh initialization
- **Hostname-based profiles** (Profiles plugin) provide machine-specific runtime config during oh-my-zsh initialization
- Re-enabled Profiles plugin with `.local` suffix normalization (single file works for both `Skuld` and `Skuld.local` hostnames)
- Removed redundant `Skuld.local` profile file
- Updated documentation to explain the dual-system architecture and load order

**Benefits:**
- Clean separation of concerns (theme/plugins vs runtime config)
- Hostname-based auto-loading for machine-specific settings
- No install script changes needed (systems work together seamlessly)

### Add Refresh/Update Mode to Install Script

**Status:** Completed 2025-10-25

Implemented `--update` flag for `new-computer-install.sh` to safely sync configuration changes after pulling repository updates.

**Features implemented:**
- Smart file syncing with timestamped backups for all changes
- Profile drift detection (detects if local profile differs from templates)
- Selective directory syncing with pattern-based preservation:
  - Claude: preserves local/, projects/, statsig/, todos/, hooks/
  - Karabiner: preserves automatic_backups/, assets/
  - Git, tmux, ncdu: full sync
- SSH config skipped entirely in update mode (manual merge recommended)
- All shell setup and package installation skipped in update mode
- Clear messaging showing unchanged vs updated files
- Dry-run support for preview
- Verbose mode for detailed output

**Usage:**
```bash
cd ~/config && git pull && ./new-computer-install.sh --update
```

Older completed items are removed from this list but visible in git history
