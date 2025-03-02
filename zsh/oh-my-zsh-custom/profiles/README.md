# oh-my-zsh profiles

## Overview

This directory contains the profiles for the `new-computer-install.sh` script. Each file in this directory is a profile that can be installed by the script. The file names are tied to the machine name. For example, if the machine name is `macbook-pro`, the profile file should be named `macbook-pro`. The machine name as displayed by the `hostname` command, and is used to determine which profile to install.

### Adding a New Profile

To add a new profile to this directory for use with the `new-computer-install.sh` script, follow these steps:

1. **Determine the Machine Name**: Run the `hostname` command on the target machine to get its name.

    ```sh
    hostname
    ```

2. **Create the Profile File**: Create a new file in this directory with the name matching the machine name obtained in the previous step.

    ```sh
    touch .../config/zsh/oh-my-zsh-custom/profiles/<machine-name>
    ```

3. **Edit the Profile File**: Open the newly created file and add the necessary configuration settings for the machine.

    ```sh
    nano .../config/zsh/oh-my-zsh-custom/profiles/<machine-name>
    ```

4. **Save and Close**: Save the changes and close the editor.

The `new-computer-install.sh` script will automatically detect and use this profile based on the machine name.
