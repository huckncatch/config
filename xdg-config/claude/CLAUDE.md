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

### Planning and Collaboration

Before executing a new plan that involves multiple steps or substantial changes:

1. **Discuss objectives and expected outcomes** - Understand what success looks like and any constraints before diving into implementation
2. **Confirm approach** - Present the planned approach briefly to ensure alignment before starting work

This helps avoid misunderstandings and wasted effort on the wrong solution.

#### Iterative Decision Making

When presenting complex analysis with multiple decisions or changes (e.g., architectural reviews, multi-file refactorings, documentation restructuring):

1. **Present one decision at a time** - Don't overwhelm with all conclusions at once
2. **Provide full context per decision** - Include both the detailed analysis and the summary/recommendation for each item
3. **Allow back-and-forth discussion** - Wait for user input before moving to the next decision
4. **Solidify each decision** - Ensure agreement on one item before proceeding to the next

This approach ensures thorough understanding and prevents decision fatigue when evaluating multiple complex changes.

### Incremental Work Process

When working through multi-step plans:

- **After completing each step**, list the remaining steps and ask the user if they want to continue or make changes to instructions or the plan
- This ensures alignment and allows for course correction before proceeding

### Safety with Sensitive Operations

When working with production systems, credentials, sensitive data, or external communications:

1. **Explicitly confirm intent** - Describe the planned action and wait for user confirmation before proceeding
2. **Be transparent about scope** - Clearly state what will be accessed, modified, or transmitted
3. **Highlight irreversible operations** - Call out destructive actions (deletions, external API calls, deployments) before executing

### Documentation Placement

When modifying CLAUDE.md files, verify that content is placed appropriately:

- **Global CLAUDE.md** (`~/.config/claude/CLAUDE.md`): Cross-project workflows, general preferences, universal coding standards
- **Project CLAUDE.md** (repository-specific): Architecture, project conventions, setup instructions, file structure

After updating either file, review both to ensure information isn't duplicated or in the wrong location.

**Critical: When modifying global CLAUDE.md in the `~/config` repository, immediately update the repository backup at `~/config/xdg-config/claude/CLAUDE.md` to keep them synchronized.** The repository version is used when provisioning new machines.

## File Editing Standards

Apply these standards to all files in any repository:

### Universal Requirements

1. **All files must end with a trailing newline** - This is standard practice for version control and POSIX compliance
2. **Markdown files must use uppercase filenames** - Use uppercase for all .md files (e.g., CLAUDE.md, README.md, NOTES.md). Subdirectories follow the same convention (e.g., homebrew/README.md, not homebrew/HOMEBREW.md)
3. **Markdown files must pass linting** - Use markdownlint (e.g., `davidanson.vscode-markdownlint` for VS Code) to validate all .md files
4. **Preserve existing code style** - Match the formatting, indentation, and conventions already in use
5. **Verify changes don't break functionality** - Test affected code paths after making changes

### Git Commit Best Practices

Philosophy: Small, incremental commits that show progression of changes

#### Proactive Commit Management

After completing any meaningful unit of work, proactively ask the user if they want to commit the changes. Don't wait for the user to request it.

**Commit after each meaningful change**, not just at the end of a multi-step plan. Each commit should represent a single logical unit of work that could be understood and potentially reverted independently.

**Meaningful work includes:**

- Completing a feature or bug fix
- Finishing a refactoring operation
- Adding or updating documentation
- Completing a logical step in a multi-step plan

**Examples of when to commit:**

- When creating new scripts/files: commit the journey incrementally (initial structure, then core logic, then error handling, then tests, etc.)
- After refactoring a single file or module
- After adding a new feature or function
- After fixing a bug
- After updating documentation to reflect code changes
- NOT after every single line change, but after each coherent piece of work

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

```text
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
5. **Avoid unnecessary emphasis words** - Be direct and factual instead of using words like "entire", "completely", "absolutely" when describing issues or constraints
6. **Review documentation for accuracy** - Avoid hallucinating or exaggerating information. If a commit message says "Remove X", X must actually be removed in that commit. Verify changes match descriptions before committing.

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
