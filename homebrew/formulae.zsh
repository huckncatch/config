# Homebrew Formulae
# One package per line, comments start with #
# Inline comments are supported: package-name # comment

# Shell & Terminal
bash # GNU Bash (Homebrew version kept current for scripting; macOS ships an ancient 3.x); https://www.gnu.org/software/bash/
emacs # GNU Emacs text editor; https://github.com/emacs-mirror/emacs
screen # GNU terminal multiplexer (older alternative to tmux); https://www.gnu.org/software/screen/
tmux # modern terminal multiplexer with scriptable sessions and panes; https://github.com/tmux/tmux
zsh # Z shell with powerful tab completion, globbing, and theming; https://www.zsh.org/

# File Management
coreutils # GNU core utilities (ls, cp, mv, etc.) with GNU extensions missing from macOS; https://www.gnu.org/software/coreutils/
eza # modern ls replacement with color, icons, and git status integration; https://github.com/eza-community/eza
fd # fast and user-friendly alternative to find with sensible defaults; https://github.com/sharkdp/fd
findutils # GNU find, xargs, and locate (GNU versions of macOS's BSD variants); https://www.gnu.org/software/findutils/
fswatch # file change monitor that runs a command when files are modified; https://github.com/emcrisostomo/fswatch
midnight-commander # dual-pane terminal file manager with built-in editor and viewer; https://github.com/MidnightCommander/mc
ncdu # ncurses-based interactive disk usage analyzer; https://dev.yorhel.nl/ncdu
tag # command-line tool to read, write, and search macOS Finder tags; https://github.com/jdberry/tag
tree # recursive directory listing in an indented tree format; https://github.com/Old-Man-Programmer/tree

# Search & Text Processing
ack # grep replacement optimized for searching source code; https://github.com/beyondgrep/ack3
fzf # command-line fuzzy finder for files, history, and arbitrary lists; https://github.com/junegunn/fzf
grep # GNU grep with extended regex (--perl-regexp support missing from macOS grep); https://www.gnu.org/software/grep/
highlight # syntax highlighter for 200+ languages to HTML, RTF, ANSI, and more; https://gitlab.com/saalen/highlight
ripgrep # extremely fast grep alternative written in Rust with .gitignore support; https://github.com/BurntSushi/ripgrep
the_silver_searcher # ag: fast code search tool optimized for large codebases (C, faster than ack); https://github.com/ggreer/the_silver_searcher

# Network & Download
curl # command-line URL transfer tool supporting 25+ protocols; https://github.com/curl/curl
openssh # OpenSSH client and server (kept current vs macOS's older bundled version); https://github.com/openssh/openssh-portable
wget # non-interactive network downloader with recursive and mirroring support; https://www.gnu.org/software/wget/
yt-dlp # download video/audio from YouTube and 1000+ sites (active youtube-dl fork); https://github.com/yt-dlp/yt-dlp

# Version Control
gh # official GitHub CLI for PRs, issues, repos, and Actions; https://github.com/cli/cli
git # distributed version control system; https://github.com/git/git
git-interactive-rebase-tool # full-featured terminal sequence editor for git rebase -i; https://github.com/MitMaro/git-interactive-rebase-tool
# git-lfs # Git extension for versioning large files (audio, video, datasets) outside the repo; https://github.com/git-lfs/git-lfs

# Media
exiftool # read, write, and edit EXIF/IPTC/XMP metadata in images, video, and audio; https://github.com/exiftool/exiftool
ffmpeg # record, convert, and stream audio and video in virtually any format; https://github.com/FFmpeg/FFmpeg
id3v2 # command-line ID3v2 tag editor for MP3 files; https://id3v2.sourceforge.net/

# Documentation & Linting
bat # cat replacement with syntax highlighting, line numbers, and Git integration; https://github.com/sharkdp/bat
cloc # count lines of code, comments, and blank lines across 100+ languages; https://github.com/AlDanial/cloc
markdownlint-cli2 # fast Markdown linter and fixer (NOTE: installs node as dependency); https://github.com/DavidAnson/markdownlint-cli2
pandoc # universal document converter between Markdown, HTML, Word, PDF, LaTeX, and more; https://github.com/jgm/pandoc
shellcheck # static analysis and linting tool for bash/sh shell scripts; https://github.com/koalaman/shellcheck
tldr # simplified, community-maintained man pages with practical examples; https://tldr.sh/

# Ruby Development
openssl@3 # OpenSSL 3.x TLS/SSL library (needed to link Rubies to Homebrew's OpenSSL); https://github.com/openssl/openssl
rbenv # lightweight Ruby version manager that uses shims; https://github.com/rbenv/rbenv
ruby-build # rbenv plugin to compile and install Ruby versions from source; https://github.com/rbenv/ruby-build

# Swift/Xcode Development
swiftformat # opinionated Swift code formatter; https://github.com/nicklockwood/SwiftFormat
swiftlint # enforce Swift style and conventions from the Kodeco (Ray Wenderlich) style guide; https://github.com/realm/SwiftLint
swiftly # official Swift toolchain version manager from the Swift project; https://github.com/swiftlang/swiftly
xcbeautify # pretty-format xcodebuild output for readability in CI and terminals; https://github.com/cpisciotta/xcbeautify
xcode-build-server # bridges xcodebuild with LSP for Xcode project support in non-Xcode editors; https://github.com/SolaWing/xcode-build-server

# Python Tools
pipx # install and run Python CLI apps in isolated virtual environments; https://github.com/pypa/pipx

# Node.js & Package Managers
pnpm # fast, disk-efficient package manager using a content-addressable store (works with nvm); https://github.com/pnpm/pnpm

# AI & ML
html2text # convert HTML to readable plain text; https://github.com/grobian/html2text
ollama # run and manage large language models locally (llama3, mistral, etc.); https://github.com/ollama/ollama

# System Utilities
blueutil # command-line Bluetooth power control and device management; https://github.com/toy/blueutil
gzip # GNU gzip compression (kept current vs macOS's older bundled version); https://www.gnu.org/software/gzip/

# Disabled
# mas # Mac App Store command-line interface for installing and updating App Store apps; https://github.com/mas-cli/mas
# python3 # installed by midnight-commander/mc
