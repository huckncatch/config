# Python configuration
#
# Python is installed via Homebrew. The `brew shellenv` in profile-base.zsh
# adds /opt/homebrew/bin to PATH, making Homebrew's Python available.
#
# Homebrew Python versions:
#   brew install python@3.13    # or python@3.12, python@3.14
#   brew link python@3.13       # makes python3/pip3 point to this version
#
# After linking, these are available:
#   python3, pip3               # from /opt/homebrew/bin
#   python3.13, pip3.13         # version-specific
#
# Note: There's no `python` or `pip` command by default (only python3/pip3).
# The OMZ python plugin provides `py` as an alias for python3.
#
# Installing packages:
#   pip3 install <package>
#   python3 -m pip install <package>
#
# OMZ Python plugin aliases (enabled via plugins array):
#   py          - Runs python3
#   pyfind      - Finds .py files recursively
#   pyclean     - Deletes byte-code and cache files
#   pygrep      - Searches in *.py files
#   pyserver    - Starts HTTP server on current directory
#
# Virtual environment utilities:
#   mkv [name]  - Create venv (default: venv)
#   vrun [name] - Activate venv
#   auto_vrun   - Auto-activate when entering directory with venv
#
# To enable auto_vrun, add to profile.local before oh-my-zsh sourcing:
#   PYTHON_AUTO_VRUN=true
#   PYTHON_VENV_NAME=".venv"  # optional, default is "venv"
