# Cross-Project Preferences

## Git Workflow

**Commit approval required**: Always show staged files + draft commit message for user
approval before running `git commit`. Never execute the commit without explicit approval.

**Use `git -C <path>` only for repos outside the cwd**: Never `cd /other/repo && git ...`.
Use `git -C /other/repo ...` instead. When already in the target repo's directory, use
plain `git` — do not add `-C` redundantly.

**Why:** `-C` is for crossing directories without leaking shell state. Using it when
already in cwd is inattentive and was corrected.

**How to apply:** If the target repo is not the current working directory, use
`git -C /path/to/repo <command>`. If cwd already is the target repo, just use `git <command>`.

## Documentation

**Keep docs current**: When making changes, update CLAUDE.md/NOTES.md (or the project's
equivalent docs) as part of the same task — not as a follow-up or separate step.

**No meta-instructions in doc files**: Don't put statements about a doc's purpose, provenance,
or maintenance (e.g. "What the app does, for whom, and why. Extracted from meeting
transcripts; keep current.") in the docs themselves. Docs hold content only.

**Why:** "Keep current" is a given, not something each file needs to announce, and
meta-statements clutter the content. Corrected on the time-tracker `docs/spec.md`.

**How to apply:** Applies to every doc file across projects. If the guidance is worth
keeping, it belongs in memory (global or project, per the layer rules below) or CLAUDE.md,
not in the doc. Scaffold placeholder lines in an empty template file (e.g. an ADR log's
"chose X over Y because Z" line) are fine until the file gets real content; remove them
once the file is put to use.

## Task Lists / TODOs

**Move completed items to the Completed section**: When marking an item done in any
TODO.md or task list, move it out of the Pending/active section and into the
Completed section (don't just check the box in place).

**Why:** Keeps the pending list showing only what's actually left to do, and preserves
a dated changelog of finished work.

**How to apply:** Applies to any to-do file or list across projects, not just one repo.

## Claude Memory Layer Selection

Project auto-memory (files in `~/.config/claude/projects/<path>/memory/`) is keyed to the
literal filesystem path of the repo. It is **not portable across machines** — the path
encoding differs between macOS (`-Users-soob-config`) and Linux (`-home-soob-config`), and
`sync-backups.sh` does not cover the `projects/` subdirectory.

Choose the right layer for the content:

| Content type | Where it belongs |
|---|---|
| Stable project context, conventions, platform notes | Project `CLAUDE.md` (version-controlled, always loaded) |
| Evolving notes, decisions, research | Obsidian vault via `obsidian-cortex` MCP (path-agnostic) |
| Behavioral corrections, workflow rules across all projects | Global memory `~/.config/claude/memory/` (synced via sync-backups.sh) |
| Project auto-memory | Only for ephemeral, single-machine context — do NOT use for anything that should transfer across machines |

**How to apply:** Before writing project memory, ask: "Does this need to be available on
another machine?" If yes, use CLAUDE.md or Obsidian instead.

## MCP Servers

**Sync both Claude clients**: When adding or changing any MCP server config, always update both:
- `~/.config/claude/settings.json` (Claude Code)
- `~/Library/Application Support/Claude/claude_desktop_config.json` (Claude Desktop)

**Why:** The same MCP servers are used across both clients. Letting them drift causes
silent failures or missing tools depending on which client is active.

**How to apply:** Treat both files as a single unit — never edit one without checking the other.
