#!/usr/bin/env python3
"""
Memory injection hook for Claude Code (PreToolUse).
Reads global + project memory files and injects them as context.
Fires at most once per session, identified by parent PID.
"""

import json
import os
import sys
from pathlib import Path

CLAUDE_DIR = Path(os.environ.get("CLAUDE_CONFIG_DIR", Path.home() / ".config" / "claude"))
MEMORY_DIR = CLAUDE_DIR / "memory"
FLAG_DIR = Path("/tmp/claude-memory-flags")


def already_ran() -> bool:
    FLAG_DIR.mkdir(exist_ok=True)
    flag = FLAG_DIR / f"ppid-{os.getppid()}"
    if flag.exists():
        return True
    flag.touch()
    return False


def read(path: Path) -> str | None:
    try:
        return path.read_text().strip()
    except (FileNotFoundError, PermissionError):
        return None


def find_project_memory() -> Path:
    project_dir = os.environ.get("CLAUDE_PROJECT_DIR", os.getcwd())
    mapped = project_dir.replace("/", "-")
    return CLAUDE_DIR / "projects" / mapped / "memory" / "MEMORY.md"


def main() -> None:
    # Consume stdin (required by hook protocol; we don't need the content)
    sys.stdin.read()

    if already_ran():
        sys.exit(0)

    parts: list[str] = []

    for filename in ["memory.md", "general.md"]:
        content = read(MEMORY_DIR / filename)
        if content:
            parts.append(content)

    project_memory = read(find_project_memory())
    if project_memory:
        parts.append(f"## Project Memory\n\n{project_memory}")

    if not parts:
        sys.exit(0)

    output = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "additionalContext": "\n\n---\n\n".join(parts),
        }
    }
    print(json.dumps(output))


if __name__ == "__main__":
    main()
