# Tmux plugin configuration
# These variables must be set BEFORE the tmux plugin loads.
# Since oh-my-zsh custom files load alphabetically and the tmux plugin
# loads during oh-my-zsh initialization, this file won't affect plugin defaults.
#
# To set these variables, add them to your profile template (profile-home.zsh)
# or to ~/.config/zsh/profile.local which loads before oh-my-zsh.
#
# Available configuration variables (defaults shown):
#
# ZSH_TMUX_AUTOSTART=false        # Auto-launch tmux when opening terminal
# ZSH_TMUX_AUTOSTART_ONCE=true    # Only autostart once per session
# ZSH_TMUX_AUTOCONNECT=true       # Attach to existing session if available
# ZSH_TMUX_AUTOQUIT=false         # Close terminal when tmux exits
# ZSH_TMUX_AUTONAME_SESSION=false # Name sessions after $PWD basename
# ZSH_TMUX_DEFAULT_SESSION_NAME=  # Fixed name for autostart sessions
# ZSH_TMUX_ITERM2=true            # Enable iTerm2 tmux integration (-CC flag)
# ZSH_TMUX_AUTOREFRESH=false      # Auto-refresh env vars before each command
# ZSH_TMUX_UNICODE=false          # Enable unicode support (-u flag)
# ZSH_TMUX_DETACHED=false         # Start sessions detached
# ZSH_TMUX_FIXTERM=true           # Auto-set $TERM based on 256-color support
# ZSH_TMUX_CONFIG=                # Auto-detected: ~/.config/tmux/tmux.conf
#
# Recommended settings to add to profile.local:
#
#   # Auto-refresh SSH_AUTH_SOCK and other env vars in long-running sessions
#   export ZSH_TMUX_AUTOREFRESH=true
#
#   # Enable unicode support
#   export ZSH_TMUX_UNICODE=true
#
#   # Name sessions after current directory
#   export ZSH_TMUX_AUTONAME_SESSION=true

# Tmux aliases (provided by the tmux plugin):
# ta      - tmux attach -t
# tad     - tmux attach -d -t
# tds     - Create/attach session for current directory
# tkss    - tmux kill-session -t
# tksv    - tmux kill-server
# tl      - tmux list-sessions
# tmuxconf - Open tmux config in $EDITOR
# ts      - tmux new-session -s
# tcs     - tmux new-session -A -s
