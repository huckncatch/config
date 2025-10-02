#!/bin/sh
# Software for provisioning up a Macbook Pro and all that good stuff.
# Cloned from Iheanyi Ekechukwu
# (https://github.com/iheanyi/dotfiles)
# Inspired by komputer-maschine by Lauren Dorman
# (https://github.com/laurendorman/komputer-maschine)

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Parse command line options
DRY_RUN=0
VERBOSE=0

show_usage() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Provision a new macOS machine with dotfiles, configurations, and applications.

OPTIONS:
  -d, --dry-run    Show what would be installed without actually installing
  -v, --verbose    Show detailed output during installation
  -h, --help       Show this help message

EXAMPLES:
  $(basename "$0")              # Run normal installation
  $(basename "$0") --dry-run    # Preview what would be installed
  $(basename "$0") -v           # Run with verbose output
  $(basename "$0") -d -v        # Preview with verbose output

EOF
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
    -h|--help)
      show_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_usage
      exit 1
      ;;
  esac
done

if [ $DRY_RUN -eq 1 ]; then
  echo "=== DRY RUN MODE - No changes will be made ==="
  echo ""
fi

# Prerequisites
# This script assumes you have Homebrew installed.
# If you don't have Homebrew installed, run:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Or visit https://brew.sh/

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
  echo "Error: Homebrew is not installed. Please install it first."
  echo "Visit https://brew.sh/ for installation instructions."
  exit 1
fi

# Check if we're in the config repository directory
if [ ! -f "./new-computer-install.sh" ]; then
  echo "Error: This script must be run from the config repository directory."
  exit 1
fi

# helper functions
_prompt_install() {
  local response
  read -r -p "$1 (y/n): " response
  if [[ $response == [Yy] || $response == "yes" ]]; then
      echo "yes"
    else
      echo "no"
    fi
}

_brew_list_does_not_contain() {
  local brew_list_output
  brew_list_output=$(brew list 2>/dev/null)
  # echo "Checking if $@ is in the brew list..."
  if [[ $brew_list_output != *"$@"* ]]; then
    # echo "yes"
    return 0
  else
    # echo "no"
    return 1
  fi
}

_should_install() {
  if _brew_list_does_not_contain "$@"; then
    proceed=$(_prompt_install "Install $@?")
    if [[ "$proceed" == "yes" ]]; then
      return 0
    else
      return 1
    fi
  else
    echo "$@ already installed, gonna skip that."
    return 1
  fi
}

brew_install() {
  if [ $DRY_RUN -eq 1 ]; then
    echo "[DRY RUN] Would install: $@"
  else
    echo "Installing $@..."
    if [ $VERBOSE -eq 1 ]; then
      brew install "$@"
    else
      brew install "$@" > /dev/null 2>&1 || {
        echo "  Error installing $@"
        return 1
      }
      echo "  ✓ Installed $@"
    fi
  fi
}

copy_zsh_config() {
  echo "Setting up zsh configuration..."

  # Copy main zshrc to home directory
  if [ -f "$HOME/.zshrc" ]; then
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would back up existing ~/.zshrc to ~/.zshrc.backup"
    else
      echo "  Backing up existing ~/.zshrc to ~/.zshrc.backup"
      cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi
  fi

  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would copy zshrc to ~/.zshrc"
  else
    cp "./zsh/zshrc" "$HOME/.zshrc" || { echo "Error: Failed to copy zshrc"; exit 1; }
    echo "  Copied zshrc to ~/.zshrc"
  fi

  # Create ~/.config/zsh directory if it doesn't exist
  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would create directory ~/.config/zsh"
  else
    mkdir -p "$HOME/.config/zsh"
  fi

  # Prompt for profile selection and create profile.local
  local profile_source
  if [ -f "$HOME/.config/zsh/profile.local" ]; then
    echo "  Profile already exists at ~/.config/zsh/profile.local, skipping."
  else
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would prompt for profile selection and create ~/.config/zsh/profile.local"
    else
      personal=$(_prompt_install "Personal/Home config?")
      if [[ "$personal" == "yes" ]]; then
        echo "  Creating home profile..."
        profile_source="./zsh/profile-home.zsh"
      else
        echo "  Creating work profile..."
        profile_source="./zsh/profile-work.zsh"
      fi

      cp "$profile_source" "$HOME/.config/zsh/profile.local" || { echo "Error: Failed to copy profile"; exit 1; }
      echo "  Created ~/.config/zsh/profile.local"
    fi
  fi
}

# Copy dotfiles to home directory
copy_dotfiles() {
  echo "Copying dotfiles..."

  for item in ./dotfiles/*; do
    if [ -e "$item" ]; then
      itemname=$(basename "$item")

      # Special handling for SSH config
      if [ "$itemname" = "ssh-config" ]; then
        if [ -f "$HOME/.ssh/config" ]; then
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would back up existing ~/.ssh/config to ~/.ssh/config.backup"
          else
            echo "  Backing up existing ~/.ssh/config to ~/.ssh/config.backup"
            cp "$HOME/.ssh/config" "$HOME/.ssh/config.backup"
          fi
        fi
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would copy SSH config to ~/.ssh/config"
        else
          echo "  Copying SSH config to ~/.ssh/config"
          mkdir -p "$HOME/.ssh"
          chmod 700 "$HOME/.ssh"
          cp "$item" "$HOME/.ssh/config"
          chmod 600 "$HOME/.ssh/config"
        fi
      else
        if [ -f "$HOME/.$itemname" ]; then
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would back up existing ~/.$itemname to ~/.$itemname.backup"
          else
            echo "  Backing up existing ~/.$itemname to ~/.$itemname.backup"
            cp "$HOME/.$itemname" "$HOME/.$itemname.backup"
          fi
        fi
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would copy $itemname to ~/.$itemname"
        else
          echo "  Copying $itemname to ~/.$itemname"
          cp "$item" "$HOME/.$itemname"
        fi
      fi
    fi
  done
}

# Copy XDG config files
copy_xdg_config() {
  echo "Copying XDG config files..."

  # Create ~/.config if it doesn't exist
  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would create directory ~/.config"
  else
    mkdir -p "$HOME/.config"
  fi

  # Copy each directory from xdg-config/ to ~/.config/
  for item in ./xdg-config/*; do
    if [ -e "$item" ]; then
      itemname=$(basename "$item")
      if [ -e "$HOME/.config/$itemname" ]; then
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would back up existing ~/.config/$itemname to ~/.config/$itemname.backup"
        else
          echo "  Backing up existing ~/.config/$itemname to ~/.config/$itemname.backup"
          cp -r "$HOME/.config/$itemname" "$HOME/.config/$itemname.backup"
        fi
      fi
      if [ $DRY_RUN -eq 1 ]; then
        echo "  [DRY RUN] Would copy directory $itemname to ~/.config/"
      else
        echo "  Copying directory $itemname to ~/.config/"
        cp -r "$item" "$HOME/.config/"
      fi
    fi
  done
}

## Homebrew taps
# Tap all required repositories before installing packages
brew_taps=(
  "buo/cask-upgrade"          # Used by brew cu command to upgrade casks
  "homebrew/cask-fonts"       # Required for font installations
)

for tap in "${brew_taps[@]}"; do
  if [ $DRY_RUN -eq 1 ]; then
    echo "[DRY RUN] Would tap: $tap"
  else
    brew tap "$tap" 2>/dev/null || echo "  Already tapped: $tap"
  fi
done

## Install oh-my-zsh
# ZSH_CUSTOM is set in the zshrc file, so it should be set before running this script.
# echo "ZSH_CUSTOM is $ZSH_CUSTOM"
# echo "ZSH is $ZSH"

# old way of installing oh-my-zsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install oh-my-zsh without changing the default shell to zsh and without running zsh after installation
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  if [ $DRY_RUN -eq 1 ]; then
    echo "[DRY RUN] Would install oh-my-zsh"
  else
    echo "Installing oh-my-zsh..."
    if [ $VERBOSE -eq 1 ]; then
      RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
      RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1 && echo "✓ Installed oh-my-zsh" || echo "Error installing oh-my-zsh"
    fi
  fi
else
  echo "oh-my-zsh already installed, skipping."
fi

## Install zsh plugins (skip if already present via git submodules)
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}"

# Define plugins as "name|repository_url"
zsh_plugins=(
  "zsh-completions|https://github.com/zsh-users/zsh-completions"
  "zsh-nvm|https://github.com/lukechilds/zsh-nvm"
  "fast-syntax-highlighting|https://github.com/zdharma-continuum/fast-syntax-highlighting"
)

# Install each plugin
for plugin_spec in "${zsh_plugins[@]}"; do
  plugin_name="${plugin_spec%%|*}"
  plugin_url="${plugin_spec##*|}"
  plugin_path="$ZSH_CUSTOM_DIR/plugins/$plugin_name"

  if [ ! -d "$plugin_path" ]; then
    if [ $DRY_RUN -eq 1 ]; then
      echo "[DRY RUN] Would install $plugin_name"
    else
      echo "Installing $plugin_name..."
      if [ $VERBOSE -eq 1 ]; then
        git clone "$plugin_url" "$plugin_path"
      else
        git clone "$plugin_url" "$plugin_path" > /dev/null 2>&1 && echo "✓ Installed $plugin_name" || echo "Error installing $plugin_name"
      fi
    fi
  else
    echo "$plugin_name already installed, skipping."
  fi
done

## Install packages
# https://formulae.brew.sh/formula/
echo "Check formulae..."
packages=(
  the_silver_searcher  # ag - grep replacement
  coreutils
  curl
  emacs
  exiftool
  eza # ls replacement
  findutils
  ffmpeg
  git
  git-interactive-rebase-tool
  # git-lfs
  grep
  gzip
  highlight
  midnight-commander
  openssh
  #python3 # installed by midnight-commander/mc
  rbenv # Ruby version manager
  screen
  tag
  tmux
  wget
  yt-dlp # youtube-dl replacement
  zsh
  # zsh-fast-syntax-highlighting, installed as OMZ sub-module custom plugins
  # zsh-syntax-highlighting

  # https://remysharp.com/2018/08/23/cli-improved
  ack  # grep replacement
  bat  # cat replacement
  # diff-so-fancy
  fd # find replacement
  fzf # fuzzy finder
  ncdu # disk usage analyzer
  ripgrep # grep replacement
  tldr #
  tree # directory listing

  # cursor development
  swiftformat
  swiftlint
  swiftly  # Swift toolchain version manager
  xcbeautify
  xcode-build-server

  # other
  # mas # Mac App Store command line interface
)

# Gather package selections
packages_to_install=()
for formula in "${packages[@]}"
do
  if _should_install "$formula"; then
    packages_to_install+=("$formula")
  fi
done

# Install selected packages
if [ ${#packages_to_install[@]} -gt 0 ]; then
  echo ""
  echo "Installing ${#packages_to_install[@]} selected packages..."
  for formula in "${packages_to_install[@]}"
  do
    brew_install "$formula"
  done
else
  echo "No packages selected for installation."
fi

# Install applications
# https://formulae.brew.sh/cask/

#abbyy-finereader-pdf
#amadeus-pro
#eaglefiler
#fluid
#keyboard-cleaner
#is built for Intel macOS and so requires Rosetta 2 to be installed.
#You can install Rosetta 2 with:
#  softwareupdate --install-rosetta --agree-to-license
#Note that it is very difficult to remove Rosetta 2 once it is installed.

echo ""
echo "Check apps..."
applications=(
  # 1password (https://1password.com/downloads/mac/) -- !! download directly !!
  # arc (https://arc.net/)
  path-finder # https://cocoatech.com/
  iterm2 # https://iterm2.com/
  itermai # https://iterm2.com/ai-plugin.html
  raycast # https://raycast.com/ -- ## Raycast Extensions
  # xcode # https://xcodereleases.com/
  # bartender # https://www.macbartender.com/
  jordanbaird-ice # https://icemenubar.app/
  maestral # https://maestral.app/
  obsidian # https://obsidian.md/
  hazel # https://www.noodlesoft.com/
  choosy # https://www.choosyosx.com/
  soundsource # https://rogueamoeba.com/soundsource/
  istat-menus # https://bjango.com/mac/istatmenus/
  usb-overdrive # https://www.usboverdrive.com/
  karabiner-elements # https://karabiner-elements.pqrs.org/ | keyboard customization savant
  mailmate@beta
  # bbedit # https://www.barebones.com/products/bbedit/ -- PINNED
  visual-studio-code # https://code.visualstudio.com/
  tower # https://www.git-tower.com/
  warp # https://www.warp.dev/
  keyclu # https://sergii.tatarenkov.name/keyclu/support/q

  # AI tools
  claude # https://claude.ai/
  claude-code # https://www.anthropic.com/claude-code
  cursor # https://www.cursor.so/

  reader # https://readwise.io/read/

  # secondary apps
  idrive # https://www.idrive.com/
  betterzip # https://macitbetter.com/
  moom # https://manytricks.com/moom/
  # betterdisplay # https://www.fadest.chttps://github.com/waydabber/BetterDisplay
  the-unarchiver # https://theunarchiver.com/
  # adapter # https://www.macroplant.com/adapter/
  # ticktick # https://www.ticktick.com/
  # tana # https://tana.app/
  # a-better-finder-rename # https://www.publicspace.net/ABetterFinderRename/ -- PINNED
  abbyy-finereader-pdf # https://www.abbyy.com/en-us/finereader/
  # alfred # https://www.alfredapp.com/
  amadeus-pro # https://www.hairersoft.com/pro.html
  audio-hijack # https://rogueamoeba.com/audiohijack/
  # audiobook-builder # https://www.splasm.com/audiobookbuilder/
  # audioranger (https://www.audioranger.com/)
  sourcetree # https://www.sourcetreeapp.com/
  beyond-compare # https://www.scootersoftware.com/
  github-copilot-for-xcode # https://github.com/github/CopilotForXcode
  brave-browser # https://brave.com/
  calibre # https://calibre-ebook.com/
  carbon-copy-cloner # https://bombich.com/
  cardhop # https://flexibits.com/cardhop
  # chatgpt # https://chatgpt.com/
  # cloudflare-warp # https://www.cloudflare.com/warp/
  # cyberduck # https://cyberduck.io/
  daisydisk # https://daisydiskapp.com/
  default-folder-x # https://www.stclairsoft.com/DefaultFolderX/
  devtoys # https://dev.toys/
  discord # https://discord.com/
  eaglefiler # https://c-command.com/eaglefiler/
  fantastical # https://flexibits.com/fantastical
  firefox # https://www.mozilla.org/en-US/firefox/new/
  fission # https://rogueamoeba.com/fission/
  # fluid # https://fluidapp.com/
  flux-app # https://justgetflux.com/
  google-chrome # https://www.google.com/chrome/
  # graphicconverter # https://www.lemkesoft.de/en/products/graphicconverter/ -- PINNED
  handbrake-app # https://handbrake.fr/
  keyboard-cleaner # https://folivora.ai/keyboardcleaner
  launchcontrol # https://www.soma-zone.com/LaunchControl/
  # logi-options-plus # https://www.logitech.com/en-us/product/options-plus
  # logitech-g-hub # https://www.logitechg.com/en-us/innovation/g-hub.html
  # logitech-options # https://www.logitech.com/en-us/product/options
  # mailmate (https://freron.com/) -- using beta version
  microsoft-edge # https://www.microsoft.com/en-us/edge
  moneydance # https://moneydance.com/
  monitorcontrol # https://github.com/MonitorControl/MonitorControl
  # mountain # https://appgineers.de/mountain/ ## deprecated
  musicbrainz-picard # https://picard.musicbrainz.org/
  mylio # https://mylio.com/
  name-mangler # https://manytricks.com/namemangler/
  netnewswire # https://ranchero.com/netnewswire/
  opera # https://www.opera.com/
  orion # https://browser.kagi.com/
  piezo # https://rogueamoeba.com/piezo/
  poe # https://poeapp.com/
  privadovpn # https://privadovpn.com/
  qlmarkdown # https://github.com/sbarex/QLMarkdown
  # reunion # https://www.reunionapp.com/ -- PINNED
  shortcutdetective # https://www.irradiatedsoftware.com/labs/
  skim # https://skim-app.sourceforge.io/
  slack # https://slack.com/
  # spotify -- problems launching after updates
  steam # https://store.steampowered.com/about/
  suspicious-package # https://www.mothersruin.com/software/SuspiciousPackage/
  # the-archive-browser -- using BetterZip instead
  # unclutter (https://unclutterapp.com/) -- hombebrew version is out of date
  vlc # https://www.videolan.org/vlc/
  # warp # https://www.warp.dev/
  xld # https://tmkk.undo.jp/xld/index_e.html
  xnviewmp # https://www.xnview.com/en/xnviewmp/

  # manual installation
  # Motion Minute # https://motionminute.app/
)

# Gather application selections
apps_to_install=()
for cask in "${applications[@]}"
do
  if _should_install "$cask"; then
    apps_to_install+=("$cask")
  fi
done

# Install selected applications
if [ ${#apps_to_install[@]} -gt 0 ]; then
  echo ""
  echo "Installing ${#apps_to_install[@]} selected applications..."
  for cask in "${apps_to_install[@]}"
  do
    brew_install "$cask"
  done
else
  echo "No applications selected for installation."
fi

# Install pinned applications (specific versions to avoid paid upgrades)
echo "Installing pinned cask versions..."
for app in ./homebrew/pinned_casks/*.rb; do
  if [ -e "$app" ]; then
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would install $(basename "$app" .rb)"
    else
      echo "  Installing $(basename "$app" .rb)..."
      if [ $VERBOSE -eq 1 ]; then
        brew install --cask "$app"
      else
        brew install --cask "$app" > /dev/null 2>&1 && echo "    ✓ Installed $(basename "$app" .rb)" || echo "    Error installing $(basename "$app" .rb)"
      fi
    fi
  fi
done

# Mac App Store applications are listed in homebrew/mas-apps.txt
# Install these manually from the Mac App Store
echo ""
echo "Note: Mac App Store apps are listed in homebrew/mas-apps.txt"
echo "Please install them manually from the App Store."

## Never been tried
# Install languages
# languages=(
#   elixir
#   go
#   ruby
# )
#
# for formula in ${languages[@]}
#   do brew_install $formula
# done

### Fonts ###
# https://github.com/githubnext/monaspace
if [ $DRY_RUN -eq 1 ]; then
  echo "[DRY RUN] Would install: font-monaspace"
else
  if [ $VERBOSE -eq 1 ]; then
    brew install font-monaspace
  else
    brew install font-monaspace > /dev/null 2>&1 && echo "✓ Installed font-monaspace" || echo "Error installing font-monaspace"
  fi
fi

## Main installation orchestrator
main() {
  # Phase 1: Configuration files (foundation)
  copy_zsh_config
  copy_dotfiles
  copy_xdg_config

  # Phase 2: Shell environment setup
  # (oh-my-zsh, plugins, taps already executed inline above)

  # Phase 3: Package installation
  # (packages, applications, pinned casks, fonts already executed inline above)

  # Phase 4: Post-installation notes
  echo ""
  echo "=== Installation Complete ==="
  echo ""
  echo "Manual steps remaining:"
  echo "- Mac App Store apps are listed in homebrew/mas-apps.txt"
  echo "- Raycast Extensions: https://www.raycast.com/extensions"
  echo "  - toothpick (Bluetooth), apple-notes, color-picker, obsidian"
  echo "  - kill-process, raindrop-io, audio-device, coffee"
}

# Run main installation
main
