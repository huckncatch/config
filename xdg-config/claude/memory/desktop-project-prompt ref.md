# Claude Desktop Project System Prompt Template

Paste the content below into the System Prompt field of a Claude Desktop Project.
Replace [PROJECT NAME] and [PROJECT NOTES] with project-specific details.

---

## Memory System

At the start of this conversation, use the `memory-files` MCP tool to read:
1. `general.md` — cross-project workflow rules (always applies)
2. `memory.md` — index of available topic files

Load additional topic files on demand as they become relevant:
- Ghostty terminal config or commands → read `tools/ghostty.md`

## Cross-Project Rules (from general.md)

- **Commit approval**: Always show staged files + draft commit message before running
  `git commit`. Never commit without explicit approval.
- **Keep docs current**: Update CLAUDE.md/NOTES.md as part of the same task, not later.

## Project: [PROJECT NAME]

[PROJECT NOTES — describe what this project is, key conventions, active work, etc.]
