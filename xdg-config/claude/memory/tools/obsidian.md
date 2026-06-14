---
name: obsidian-search-guidelines
description: How to reliably find and read notes via mcp__obsidian-cortex tools — search limitations, path conventions, and AND-search workaround
metadata:
  type: feedback
---

## Finding Notes

**Prefer `list_notes` + `read_note` over content search when the location is known.**
Use `search` only when browsing blind (unknown vault location).

**Why:** `list_notes` navigates directory structure reliably; `search` fails if your keywords don't appear verbatim in the note content.

**How to apply:** When the user says "there's a note about X in Y/Z", use `list_notes` on that path first, then `read_note` with the exact filename.

## `read_note` Path Convention

Always include the `.md` extension in the path. `Development/Tools/things-mcp` fails; `Development/Tools/things-mcp.md` works.

**Why:** The tool does not auto-append extensions — omitting `.md` returns "Note not found" even when the file exists.

## Multi-Word Search: No AND Support

The `search` tool runs ripgrep as a literal string. Multi-word queries like `"things uvx"` are treated as a verbatim phrase, not individual AND terms. Lookahead regex (`(?=.*things)(?=.*uvx)`) also returns no matches.

**Workaround:** Search for the single most unique/specific keyword from your intent (e.g., `uvx` instead of `things uvx`), then `read_note` to verify the result contains the other terms.

**How to apply:** Never search with multiple space-separated words expecting AND behavior. Pick one narrow keyword, search, then read to confirm.

## Search Fallback: Cortex Can Miss Notes

If `mcp__obsidian-cortex__search` returns no matches, fall back to filesystem grep:
```bash
grep -ri "search term" "/Users/soob/Dropbox/Apps/Obsidian/" --include="*.md" -l
```
This finds notes that the cortex server's index misses.

## Writing Files in Obsidian

**The obsidian-cortex MCP tools are reliable** — use `create_note`, `write_note`, `edit_note` as appropriate. The `Write` filesystem tool also works and is a valid alternative.

**Note:** A different, older MCP server (`mcp__obsidian__create_vault_file`) had silent failure issues. That does not apply to obsidian-cortex.

**Always read-back verify** after any write operation — confirm the file content was saved correctly.

## Metadata-Menu Class Conventions

**Always apply `fileClass` frontmatter** when creating notes in the Home vault. This enables the metadata-menu plugin to manage structured fields.

**Available classes** (definitions at `Home/90_Organize/Classes/`):

| Class | Use for | Key fields beyond `tags`/`date` |
|-------|---------|----------------------------------|
| `all` | Base — inherited by all | `tags`, `date` |
| `note` | General notes | (extends all) |
| `project` | Project tracking | `status`, `priority`, `completed` |
| `person` | People/contacts | `url`, `email`, `company`, `phone` |
| `article` | Saved articles | (extends all) |
| `bookmark` | URL bookmarks | (extends all) |
| `daily` | Daily journal entries | (extends all) |
| `claude` | Claude Code artifacts (base) | `status` |
| `claude-decision` | Design/architecture decisions | `status`, `impact` |
| `claude-research` | Research findings | `status` |
| `claude-plan` | Implementation plans | `status` |
| `claude-artifact` | Generated code/templates | `status`, `artifact_type` |

**Claude working files go to** `Home/90_Organize/Claude/`:
- `decisions/` → filename: `YYYY-MM-DD-topic-name.md`, fileClass: `claude-decision`
- `research/` → filename: `topic-name.md`, fileClass: `claude-research`
- `plans/` → filename: `topic-name.md`, fileClass: `claude-plan`
- `artifacts/` → filename: `descriptive-name.ext`, fileClass: `claude-artifact`

**Valid `status` values** vary by class:
- `project`: idea, active, complete, on-hold, abandoned
- `claude` and subclasses: draft, active, completed, on-hold, deprecated

**`impact` values** (claude-decision only): low, medium, high
