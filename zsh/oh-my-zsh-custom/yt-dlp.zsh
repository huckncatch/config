# ==============================================================================
# YT-DLP CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# yt-dlp: feature-rich video/audio downloader (youtube-dl fork)
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

if [[ -o interactive ]]; then

  # Download video using cookies from ./cookies.txt, recoded to mp4
  alias yt='yt-dlp --cookies ./cookies.txt --recode-video mp4 -o "%(title)s.%(ext)s"'

fi
