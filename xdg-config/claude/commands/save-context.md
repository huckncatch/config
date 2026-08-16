# Save Context

Create a session checkpoint in the Obsidian vault so a fresh session (after `/clear` or in a new chat) can resume this work without re-deriving context. Writes to the vault's `Home/90_Organize/Claude/` session-state convention — see that directory's `README.md` § Session State Management.

## Steps

1. **Determine the project name** — same precedence as `vault-init`: `package.json`/`Cargo.toml`/`Package.swift` "name" field, else git remote, else current directory name. Sanitize for filesystem safety (strip/replace characters illegal in filenames, collapse whitespace to hyphens). If `$ARGUMENTS` was passed, sanitize it the same way and append it as a topic qualifier — `<Project>_<Topic>`, not a replacement — so the checkpoint stays traceable to its repo.

2. **Build today's path** — `Home/90_Organize/Claude/SESSION_STATE_<Project>[_<Topic>]_<YYYY-MM-DD>.md`. Check via `obsidian-cortex` `list_notes` on that directory whether a file at this exact path already exists. If it does, append the current time instead of overwriting — `..._<YYYY-MM-DD>_<HHMM>.md` — since a same-day collision means a distinct earlier checkpoint exists and shouldn't be destroyed.

3. **Read the template** — `Home/90_Organize/Claude/SESSION_STATE_TEMPLATE.md` via `obsidian-cortex`, for its current section structure and frontmatter keys. This is the single source of truth, read fresh every run — don't hardcode section names here, the template may evolve. If it can't be read, stop and tell the user rather than guessing at a structure.

4. **Fill in each section from this conversation.** As of this writing the template has 5 sections — Session Goal, Current Status, Pending Tasks, Key Decisions & Context, Resume Prompt — but defer to whatever the template actually says:
   - **Session Goal** — 2-3 sentences: the overall goal/task this session
   - **Current Status** — what's done, current state, files created/modified (full paths), decisions made, last action taken
   - **Pending Tasks** — prioritized numbered list of what's left
   - **Key Decisions & Context** — libraries chosen, architecture, naming conventions, credential/config locations, environment details, blockers, anything non-obvious the next session needs
   - **Resume Prompt** — a fenced code block instructing the next session to read the checkpoint via the `obsidian-cortex` `read_note` tool (vault-relative path), not a `@file` shorthand — this skill works from any project directory, and a relative `@`-style reference only resolves if the next session happens to start from the vault root. State the immediate next step explicitly.

5. **Write the note** via `obsidian-cortex` `create_note` at the path from step 2, with frontmatter copied from the template's own frontmatter block, filling in `date: <today>`, `status: active`, and `project: <Project>`.

6. **Report** the vault path back to the user and print the Resume Prompt section so it can be copied directly into the next session.
