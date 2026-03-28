# ==============================================================================
# OLLAMA CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# Configuration for Ollama local LLM runtime
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

if [[ -o interactive ]]; then

  # Check whether the Ollama process is currently running
  alias ollamaup='pgrep -x ollama && echo "running" || echo "not running"'

fi
