# ==============================================================================
# NODE.JS CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# Contains Node.js and npm-specific aliases
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# Exclude CLAUDECODE to prevent aliases from persisting in snapshots (see 01_aliases.zsh)
if [[ -o interactive && -z "$CLAUDECODE" ]]; then
  # node package manager
  alias nrt='npm run transpile'
  alias nrs='npm run start'
  alias nrts='nrt && nrs'
  alias nrtest='npm run test'

  alias npmlatest='npm install -g npm@latest'
fi
