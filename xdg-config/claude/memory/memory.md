# Global Memory Index

> Read at every session start. Keep this file under 30 lines.
> Full content lives in topic files — load them on demand per routing rules below.

## Always Load

- `general.md` — cross-project workflow rules (git, docs). Load every session.

## Tool Files (load when relevant)

- `tools/ghostty.md` — Ghostty terminal CLI syntax and quirks
- `tools/obsidian.md` — Obsidian search limitations, path conventions, AND-search workaround

## Routing Rules

| Context | Load |
| --- | --- |
| Any git operation | `general.md` (always loaded) |
| Documentation tasks | `general.md` (always loaded) |
| Ghostty config, terminal questions | `tools/ghostty.md` |
| Any Obsidian note lookup or search | `tools/obsidian.md` |
