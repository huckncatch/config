# Tips, Tricks, and Settings

## enable word jumping in iTerm2

Use ⌥ + <-/-> (left/right arrow) to jump from one word to the next

- From preferences, go to “Profiles”. Under the “Keys”, click “Key Mappings” then the “+” to create a new Key Mapping.
- From the "Action" drop-down, select “Send Escape Sequence”.
- For left, enter the keyboard shortcut ⌥+left arrow, and Esc+ ‘b’
- For right, enter the keyboard shortcut ⌥+right arrow, and Esc+ ‘f’

## [Fix for 'git-credential-osxkeychain wants to access key "github.com" in your keychain'](https://stackoverflow.com/a/71936715/662731)

OSX prompts for a password every time you use git after brew upgrades git. To make Keychain Access trust git with the password again, you have to open Keychain Access, search for github under Keychain: login, kind: Internet password, and add the new path to git-credential-osxkeychain.

Or, just delete the github password and regenerate the Personal Access Token again. (source: [Fixing the git-credential-osxkeychain password prompts on every git transaction](https://dominoc925.blogspot.com/2019/11/fixing-git-credential-osxkeychain.html))

## [Permanently prevent macOS High Sierra from reopening apps after a restart](https://apple.stackexchange.com/a/309140/234778)

```bash
% sudo rm -f ~/Library/Preferences/ByHost/com.apple.loginwindow*
% touch ~/Library/Preferences/ByHost/com.apple.loginwindow*
% sudo chown root ~/Library/Preferences/ByHost/com.apple.loginwindow*
% sudo chmod 000 ~/Library/Preferences/ByHost/com.apple.loginwindow*
```

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
