# Cross-Project Preferences

## Git Workflow

**Commit approval required**: Always show staged files + draft commit message for user
approval before running `git commit`. Never execute the commit without explicit approval.

## Documentation

**Keep docs current**: When making changes, update CLAUDE.md/NOTES.md (or the project's
equivalent docs) as part of the same task — not as a follow-up or separate step.

## MCP Servers

**Sync both Claude clients**: When adding or changing any MCP server config, always update both:
- `~/.config/claude/settings.json` (Claude Code)
- `~/Library/Application Support/Claude/claude_desktop_config.json` (Claude Desktop)

**Why:** The same MCP servers are used across both clients. Letting them drift causes
silent failures or missing tools depending on which client is active.

**How to apply:** Treat both files as a single unit — never edit one without checking the other.
