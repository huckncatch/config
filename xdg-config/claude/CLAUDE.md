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

1. **Write clear, descriptive commit messages**:
   - First line: concise summary (50 chars or less)
   - Blank line, then detailed explanation if needed
   - Focus on "why" rather than "what" (the diff shows "what")
2. **Make atomic commits** - Each commit should represent one logical change
3. **Review diffs before committing** - Use `git diff` and `git status` to verify what's being committed
4. **Don't commit sensitive information** - API keys, tokens, passwords, or credentials should never be in commits

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
