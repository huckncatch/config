# Tips, Tricks, and Settings

## Raycast

Add `.../Dropbox/ApplicationSupport/Raycast/CommandScripts` as watch directory for Raycast Script Commands (Extension)

### Toothpick
Toothpick is a Raycast extension that allows you to control Bluetooth devices from the command line. It requires the `blueutil` command-line tool to be installed. Follow the "Enabling 'blueutil' backend" instructions in the [README](https://www.raycast.com/VladCuciureanu/toothpick#readme) file.

## Maestral

keep-alive instructions: https://daringfireball.net/2023/07/nerding_out_with_maestral_launchcontrol_and_keyboard_maestro

## BBEdit

Before launching, create a symlink to `~/Dropbox/Apps/BBEdit` in `~/Library/Application Support`

    ln -s ~/Dropbox/Apps/BBEdit .

## iTerm2: enable word jumping

Use ⌥ + <-/-> (left/right arrow) to jump from one word to the next

- From preferences, go to “Profiles”. Under the “Keys”, click “Key Mappings” then the “+” to create a new Key Mapping.
- From the "Action" drop-down, select “Send Escape Sequence”.
- For left, enter the keyboard shortcut ⌥+left arrow, and Esc+ ‘b’
- For right, enter the keyboard shortcut ⌥+right arrow, and Esc+ ‘f’

## `brew cu`

Upgrade all outdated casks

### Prevent updating cask with `bcu` -- pin a specific cask version

To install a specific version of a cask/formula, follow the instructions [here](https://stackoverflow.com/a/66477916/662731)

1. Go to the Homebrew Cask [search page](https://formulae.brew.sh/cask/)
1. Search for the application you are looking for
1. Click Cask code link
1. On Github click History button
1. Find the version you need by reading the commit messages and view the raw file (hover text: View code at this point). Confirm the version variable (normally on line 2) is the version you need.
    - Click on the name of the commit, then three dots and select View file
1. Right-click Raw button and "Save Link As..." to download the file locally
1. Move to ~/config/homebrew/pinned_casks
1. Run `brew install --cask ~/config/homebrew/pinned_casks/<FORMULA_NAME>.rb`
1. Voilà 😄

When `bcu` shows an update available, choose interactive mode and pin to exclude it from updates, or use `bcu --pin <FORMULA_NAME>` to pin it.

## [Fix for 'git-credential-osxkeychain wants to access key "github.com" in your keychain'](https://stackoverflow.com/a/71936715/662731)

OSX prompts for a password every time you use git after brew upgrades git. To make Keychain Access trust git with the password again, you have to open Keychain Access, search for github under Keychain: login, kind: Internet password, and add the new path to git-credential-osxkeychain.

Or, just delete the github password and regenerate the Personal Access Token again. (source: [Fixing the git-credential-osxkeychain password prompts on every git transaction](https://dominoc925.blogspot.com/2019/11/fixing-git-credential-osxkeychain.html))

## [Permanently prevent macOS High Sierra from reopening apps after a restart](https://apple.stackexchange.com/a/309140/234778)

> [!WARNING] This is broken in macOS 26 Tahoe and later

```bash
% sudo rm -f ~/Library/Preferences/ByHost/com.apple.loginwindow*
% touch ~/Library/Preferences/ByHost/com.apple.loginwindow*
% sudo chown root ~/Library/Preferences/ByHost/com.apple.loginwindow*
% sudo chmod 000 ~/Library/Preferences/ByHost/com.apple.loginwindow*
```

## Speed the Dock open/close animation

`defaults write com.apple.dock autohide-time-modifier -float 0.15;killall Dock`

## Prevent FigmaAgent from launching on startup

- remove FigmaAgent.app

    ```bash
    % rm -fr ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```

- create a dummy file

    ```bash
    % touch ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```

- make the file undeletable

    ```bash
    % sudo chflags -R schg ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```

Now Figma will not be able to override that file when it wants to update it. Also the login item does not get created for me again after removal at this point

### revert the changes

- remove the schg flag

    ```bash
    % sudo chflags -R noschg ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```

- remove the dummy file

    ```bash
    % rm -fr ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```
