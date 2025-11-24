# Claude Code Session Management

This directory contains Claude Code configuration and session state management for this repository.

## Contents

- `settings.json` - Living backup of `~/.claude/settings.json` (user settings with permissions/env vars)
- `SESSION_STATE_TEMPLATE.md` - Template for creating session state documents
- `sessions/` - Session state files (gitignored)

## Session State Management

Use session states to preserve context when ending a long session or when context usage is getting high.

### When to Create a Session State

- Before clearing context after a productive session
- When context usage exceeds ~60-70%
- Before switching to a different project mid-task

### How to Create One

Copy-paste this prompt:

```text
Before I clear context, create a session state document.

Use the template at `claude/SESSION_STATE_TEMPLATE.md` to create a file called `claude/sessions/SESSION_STATE_YYYY-MM-DD.md`.

Fill in all sections based on our current session. Format everything so the next Claude session can pick up exactly where we left off.
```

### How to Resume from a Session State

Use the resume prompt from Section 7 of the session state file, or:

```text
Let's continue our previous work.

First, read the session state: @claude/sessions/SESSION_STATE_YYYY-MM-DD.md

Please confirm you've loaded the context, then proceed with the next steps listed there.
```

## Integration with Project

When starting a new session:

1. Check `CLAUDE.md` for project context and guidelines
2. Check `TODO.md` for planned work items
3. Review recent session states if resuming previous work

---

**Location:** `~/config/claude/`
