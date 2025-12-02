# ==============================================================================
# GENERAL ENVIRONMENT CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
# Loading order: First (00_ prefix ensures it loads before other custom files)
#
# Contains general environment variables, PATH configuration, and tool setup
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# ==============================================================================
# EDITOR CONFIGURATION
# ==============================================================================

# Default editor (used by tmux, git, and other tools that spawn editors)
export EDITOR="emacs"
export VISUAL="$EDITOR"

# ==============================================================================
# COLOR CONFIGURATION
# ==============================================================================

# LS_COLORS: Configures colors for file types in ls output
# Format: file_type=color_code (e.g., di=01;34 for bold blue directories)
export LS_COLORS='bd=40;33;01:cd=40;33;01:di=01;34:ex=100;01;33:fi=00:ln=01;36:no=00:or=40;31;01:pi=40;33:so=01;35:*.aac=01;34:*.app=01;33:*.arj=01;31:*.asf=01;35:*.avi=01;35:*.bin=01;31:*.bmp=01;35:*.bz2=01;31:*.c=01;36:*.cgi=01;36:*.cpp=01;36:*.dmg=01;32:*.flac=01;34:*.gif=01;35:*.gz=01;31:*.h=01;37:*.hqx=01;31:*.jpg=01;35:*.JPG=01;35:*.js=01;36:*.lzh=01;31:*.m=01;36:*.m4a=01;34:*.m4v=01;35:*.md=01;37:*.mkv=01;35:*.mov=01;35:*.mp3=01;34:*.mp4=01;34:*.mpg=01;35:*.pdf=01;35:*.php=01;36:*.pl=01;36:*.png=01;35:*.sh=01;36:*.sit=01;31:*.sitx=01;31:*.smi=01;32:*.swift=01;36:*.tar=01;31:*.taz=01;31:*.tcl=01;36:*.tgz=01;31:*.tif=01;35:*.tiff=01;35:*.ts=01;36:*.webm=01;35:*.wmv=01;35:*.xml=01;37:*.yml=01;37:*.z=01;31:*.Z=01;31:*.zip=01;31:*.zsh=01;36:'

# Enable colored output in ls (macOS)
export CLICOLOR=1

# ==============================================================================
# PATH CONFIGURATION
# ==============================================================================

# System paths
export PATH="/usr/local/sbin:$PATH"

# Homebrew GNU utilities (prefer over BSD versions)
# These replace macOS built-in tools with more feature-complete GNU versions
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix curl)/bin:$PATH"
export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix grep)/libexec/gnubin:$PATH"

# Ruby version manager
export PATH="$HOME/.rbenv/bin:$PATH"

# Personal scripts and binaries
export PATH="$HOME/bin:$PATH"

# ==============================================================================
# SHELL INTEGRATIONS
# ==============================================================================

# iTerm2 shell integration
# Provides features like command history, shell marks, and captured output
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# VSCode shell integration
# Provides command tracking, current working directory detection, and exit code capture
# Using hardcoded path instead of `code --locate-shell-integration-path zsh` to avoid
# startup delay from launching Node.js. Update this path if VSCode installation changes.
[[ "$TERM_PROGRAM" == "vscode" ]] && . "/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration-rc.zsh"

# Note: Cross-platform dynamic approach (slower due to Node.js startup):
# [[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# ==============================================================================
# LANGUAGE/TOOL INITIALIZATION
# ==============================================================================

# rbenv - Ruby version manager
# https://github.com/rbenv/rbenv
# --no-rehash: Speeds up shell initialization by skipping shim rehashing
eval "$(rbenv init - --no-rehash zsh)"

# Ruby build configuration
# Links Ruby installations to Homebrew's OpenSSL for automatic security updates
# ruby-build normally installs a separate OpenSSL per Ruby version that never upgrades
# For Ruby 3.1+: requires OpenSSL 3 (brew install openssl@3 readline libyaml gmp)
# For Ruby 2.x-3.0: use OpenSSL 1.1 (brew install openssl@1.1 readline libyaml gmp)
# See: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

# nvm - Node version manager
# Using zsh-nvm plugin (loaded in profile) instead of official nvm installation
# Plugin provides lazy loading for faster shell startup
# NVM_DIR is set automatically by the plugin
#
# Reference: Official nvm installation (not used):
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ==============================================================================
# DEPRECATED/REFERENCE CONFIGURATIONS
# ==============================================================================

# Hostname configuration for oh-my-zsh profiles plugin
# These don't appear to be needed - plugin works without them
# Kept for reference in case issues arise with hostname detection
#
# export HOST=$(hostname)
#
# if [[ "$OSTYPE" = darwin* ]]; then
#   # macOS: Use ComputerName instead of hostname because $HOST changes with
#   # DHCP, network changes, etc. ComputerName is stable across network changes.
#   export SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST="${HOST/.*/}"
# else
#   export SHORT_HOST="${HOST/.*/}"
# fi
