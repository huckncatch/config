# Notes

## Java

Using [these](https://johnathangilday.com/blog/macos-homebrew-openjdk/) instructions to manage java using Homebrew

### For Minecraft

Use [these instructions](https://minecrafthopper.net/help/installing-java/)

## Homebrew applications

Some applications are pinned to prevent updating to paid version upgrades. To save the current list:

    brew cu pinned --export ~/config/homebrew/homebrew-cu-pinned-casks

To injest:

    brew cu pinned --load ~/config/homebrew/homebrew-cu-pinned-casks
