# Vault Init

Connect the current project to the shared Obsidian "second brain" knowledge base. See the `second-brain` skill for conventions and templates — use it for the details below.

## Steps

1. **Check if already connected** - look for a "## Cross-repo documentation (Obsidian)" section in this project's CLAUDE.md. If found, report that it's already configured and stop.

2. **Special case** - if the current project IS the Obsidian vault (`/Users/soob/Dropbox/Apps/Obsidian`), stop and explain it's the hub, not a spoke — it documents this role directly in its own CLAUDE.md instead.

3. **Determine project name and type**
   - Name: from `package.json`/`Cargo.toml`/`Package.swift` "name" field, git remote, Xcode project name, or the directory name — in that preference order
   - Type: dev/code if a manifest or build file is present (`package.json`, `Cargo.toml`, `go.mod`, `requirements.txt`, `*.xcodeproj`, `Package.swift`, etc.); otherwise non-dev

4. **Find or create the vault project note**
   - Search the vault (via `obsidian-cortex` `search`/`list_notes`) for an existing note matching the project name
   - If found, use its path
   - If not found:
     - Dev projects: create `Home/Development/Projects/<Name>.md` with `fileClass: project` frontmatter (status: idea, priority: medium, tags, date: today) and a short stub body (what the project is, repo path)
     - Non-dev projects: ask the user which existing vault topic folder fits best, then create the note there with the same frontmatter

5. **Add the CLAUDE.md section**
   - If the project has no CLAUDE.md, create one containing just this section
   - Otherwise, append the "Cross-repo documentation (Obsidian)" section from the `second-brain` skill template, filled in with the actual note path and a project-appropriate "update that note when..." clause

6. **Report** what was created or changed: the vault note path and the CLAUDE.md section added.
