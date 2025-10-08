# Global Claude Code Guidelines

This file provides guidance to Claude Code for all projects.

## Working with Claude Code

When working in any repository, Claude should proactively remind the user to add information to CLAUDE.md when:

- Discovering architectural patterns or conventions not yet documented
- Creating workarounds for tricky issues (e.g., installation conflicts, permission problems)
- Establishing new workflows or procedures
- Finding non-obvious repository-specific behaviors
- Adding custom scripts or functions that future sessions should know about

**Tip**: Use `#` in chat to quickly memorize information and add it to CLAUDE.md without manual file editing.

## File Editing Standards

Apply these standards to all files in any repository:

### Universal Requirements

1. **All files must end with a trailing newline** - This is standard practice for version control and POSIX compliance
2. **Markdown files must pass linting** - Use markdownlint (e.g., `davidanson.vscode-markdownlint` for VS Code) to validate all .md files
3. **Preserve existing code style** - Match the formatting, indentation, and conventions already in use
4. **Verify changes don't break functionality** - Test affected code paths after making changes

### Git Commit Best Practices

**Philosophy: Small, incremental commits that show progression of changes**

#### Size and Scope
1. **One logical change per commit** - If you describe it with "and", consider splitting it
2. **Maintain flexibility** - Don't be pedantic; group related changes when it makes sense
3. **Each commit should leave code in a working state** - No broken intermediate states
4. **Plan multi-step work upfront** - List commits in sequence before starting

#### Commit Sequence Planning
When tackling larger work:
1. **First commit**: Add infrastructure (new functions, flags, argument parsing)
2. **Middle commits**: Apply changes incrementally by feature area
3. **Final commit**: Documentation, cleanup, polish

Example breakdown for adding dry-run mode:
- `feat: Add command-line argument parsing (--dry-run, --verbose, --help)`
- `fix: Add DRY_RUN checks to brew operations`
- `fix: Add DRY_RUN checks to git clone operations`
- `refactor: Fix variable scoping and array quoting`
- `feat: Add verbose mode support to installations`

#### Commit Message Format (Conventional Commits)
Use this format: `<type>: <description>`

**Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code restructuring without behavior change
- `docs:` - Documentation only
- `test:` - Test additions/changes
- `chore:` - Maintenance tasks (dependency updates, etc.)

**Message Structure:**
```
type: Short summary in imperative mood (50 chars max)

- Optional body explaining why and how
- Include context, alternatives considered
- Reference issues/tickets when applicable
- Focus on "why" rather than "what" (the diff shows "what")
- Enclose commands, code, and flags in backticks for readability
  (e.g., `brew install`, `set -euo pipefail`, `--dry-run`)
```

**Examples:**
- `feat: Add dry-run flag to preview changes`
- `fix: Handle missing SSH config gracefully`
- `refactor: Extract brew installation logic to helper function`
- `docs: Add troubleshooting section to README`

#### Before Committing
1. **Review the staged diff**: `git diff --staged` - Does it tell a clear story?
2. **Verify commit message quality**: Imperative mood, explains what and why
3. **Check for sensitive data**: No API keys, tokens, passwords, or credentials
4. **Confirm logical grouping**: Should this be split or combined?

#### Traceability
- Use `git log --oneline --graph` to verify the commit history tells a clear story
- Reference file locations with `file_path:line_number` when discussing changes
- Link related commits in messages when building on previous work

### Code Quality

1. **Prefer editing existing files over creating new ones** - Unless explicitly required
2. **Add comments for non-obvious logic** - Explain "why" not "what"
3. **Handle errors gracefully** - Don't let errors fail silently
4. **Keep functions focused** - Single responsibility principle

### Communication with User

1. **Be concise** - Match verbosity to task complexity (see Claude Code tone guidelines)
2. **Ask for clarification** - When requirements are ambiguous or multiple approaches exist
3. **Explain non-obvious changes** - Especially for system modifications or destructive operations
4. **Provide context for suggestions** - Help users understand recommendations
5. **Never hallucinate or claim work not done** - If a commit message says "Remove X", X must actually be removed in that commit. Verify changes match descriptions before committing.

## Tool Usage

1. **Use specialized tools over bash commands**:
   - Read tool for reading files (not `cat`, `head`, `tail`)
   - Edit tool for editing files (not `sed`, `awk`)
   - Write tool for creating files (not `echo >` or `cat <<EOF`)
   - Grep tool for searching file contents (not bash `grep` or `rg` commands)
   - Glob tool for finding files by pattern (not `find` or `ls` commands)
2. **Batch independent operations** - Make multiple tool calls in a single message when operations don't depend on each other
3. **Use Read before Edit or Write** - Always read existing files before modifying them
4. **Verify file paths exist** - Check parent directories before creating files in nested paths

## Memory and Context Management

1. **Keep CLAUDE.md files up to date** - Both global and project-specific
2. **Reference file locations with line numbers** - Use `file_path:line_number` format when discussing code
3. **Document workarounds and gotchas** - Future Claude instances benefit from your discoveries
4. **Note dependencies and prerequisites** - Especially for setup or build processes
