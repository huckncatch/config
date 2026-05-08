#!/bin/sh
# Starts things-mcp in a detached tmux session. Safe to run multiple times.
TMUX=/opt/homebrew/bin/tmux
UVX=/opt/homebrew/bin/uvx

$TMUX has-session -t things-mcp 2>/dev/null || \
  $TMUX new-session -d -s things-mcp "$UVX things-mcp"
