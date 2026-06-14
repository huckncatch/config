# Cross-Project Preferences

## Git Workflow

**Commit approval required**: Always show staged files + draft commit message for user
approval before running `git commit`. Never execute the commit without explicit approval.

**Use `git -C <path>` for repos outside the cwd**: Never `cd /other/repo && git ...`.
Use `git -C /other/repo ...` instead, so the shell's working directory stays put.

**Why:** User corrected this explicitly — `cd &&` compounds change session state
unnecessarily and the project CLAUDE.md already bans `cd <current-dir> &&` patterns;
`git -C` is the general-purpose fix for any target directory.

**How to apply:** Any time a git command targets a directory other than the current
working directory (e.g. working in `~/config` but committing in a project repo).

## Documentation

**Keep docs current**: When making changes, update CLAUDE.md/NOTES.md (or the project's
equivalent docs) as part of the same task — not as a follow-up or separate step.

## Task Lists / TODOs

**Move completed items to the Completed section**: When marking an item done in any
TODO.md or task list, move it out of the Pending/active section and into the
Completed section (don't just check the box in place).

**Why:** Keeps the pending list showing only what's actually left to do, and preserves
a dated changelog of finished work.

**How to apply:** Applies to any to-do file or list across projects, not just one repo.

## MCP Servers

**Sync both Claude clients**: When adding or changing any MCP server config, always update both:
- `~/.config/claude/settings.json` (Claude Code)
- `~/Library/Application Support/Claude/claude_desktop_config.json` (Claude Desktop)

**Why:** The same MCP servers are used across both clients. Letting them drift causes
silent failures or missing tools depending on which client is active.

**How to apply:** Treat both files as a single unit — never edit one without checking the other.
