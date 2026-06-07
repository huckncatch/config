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
