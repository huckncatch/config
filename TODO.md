# TODO

Future improvements and features for this configuration repository.

## Planned Work

### Script to Organize Timestamped Files

Priority: High

Create a script to move files with timestamp prefixes (e.g., `2025-10-11_13-31-00.*`) into appropriate directories with duplicate handling.

- Parse timestamp format from filenames
- Determine appropriate destination directories (by date, file type, or other criteria)
- Handle duplicates with suffix notation (-1, -2, etc.)
- Provide dry-run mode to preview moves
- Add safety checks to prevent data loss
- Status: Not started

### Update Work Profile Template to use my-jonathan Theme

Currently both profile templates use Powerlevel10k by default. Update `zsh/profile-work.zsh` to use my-jonathan theme as the default instead.

- Make my-jonathan the default theme
- Keep P10k as a good example in documentation for tools that don't support XDG paths
- Status: Not started

### Review Home Directory Dotfiles for XDG Compliance

Audit dotfiles in `~/` to identify candidates that could be moved to `~/.config/` following the XDG Base Directory specification.

- Review current dotfiles in home directory
- Research which tools support XDG paths
- Create migration plan for compatible dotfiles
- Update install script and documentation
- Status: Not started

### Extract Formula and Cask Lists from Install Script

Currently package/application arrays are hardcoded in `new-computer-install.sh`. Consider extracting them for better organization.

- Evaluate options: separate files, profile templates, or other locations
- Determine if packages should be profile-specific (home vs work)
- Update install script to read from external source
- Update documentation
- Status: Not started

### Add Refresh/Update Mode to Install Script

Allow re-running `new-computer-install.sh` after pulling updates to sync new files/configurations without data loss.

- Review what currently gets overwritten vs preserved
- Identify potential data/configuration loss scenarios
- Implement smart merge/update logic
- Add `--update` or similar flag
- Test thoroughly to ensure no data loss
- Document the refresh workflow
- Status: Not started

### Consolidate Profile Systems

Two profile systems currently exist: the current `profile-home.zsh` / `profile-work.zsh` system used by `new-computer-install.sh`, and the older Profiles plugin in `zsh/oh-my-zsh-custom/plugins/profiles/` (currently disabled).

- Review the Profiles plugin functionality and benefits
- Determine which features from each system should be retained
- Design unified profile management approach
- Update install script if needed
- Consolidate or remove redundant profile directories
- Update documentation to reflect single profile system
- Status: Not started

### Resolve Homebrew Node vs zsh-nvm Conflict

The `markdownlint-cli2` Homebrew formula installs Node as a dependency, which conflicts with the zsh-nvm plugin used for Node version management.

- Investigate whether Homebrew Node can be safely uninstalled while keeping markdownlint-cli2
- Test if markdownlint-cli2 works with zsh-nvm's Node instead of Homebrew's Node
- Consider alternative solutions:
  - Use npm global install of markdownlint-cli2 (via nvm-managed Node)
  - Use different markdown linter that doesn't require Node
  - Document workaround if both installations must coexist
- Document the recommended approach in CLAUDE.md or install script
- Status: Not started

## Ideas / Future Consideration

Items that need more thought or may not be implemented

- None currently

## Completed

Completed items are removed from this list but visible in git history
