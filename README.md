# .dotfiles

This repository contains my personal dotfiles configuration for both macOS and Windows environments.

## Overview

These dotfiles help maintain consistent development environments across different machines. They include configuration files and setup scripts for various tools and applications on macOS and Windows.

## Installation (macOS)

Run the setup script to automatically install Homebrew, all Brewfile dependencies, Oh My Zsh, zsh-bat, symlink your dotfiles, and set up your iTerm2 profile:

```zsh
cd ~/.dotfiles
zsh mac/setup-mac.sh
```

This will:

- Install Homebrew (if not already installed)
- Install all apps and packages from the Brewfile
- Install Oh My Zsh (if not already installed)
- Install the zsh-bat plugin
- Symlink `.zshrc`, `.gitconfig`, and `.p10k.zsh` to your home directory
- Symlink your iTerm2 profile (`mac/com.googlecode.iterm2.plist`) to the iTerm2 DynamicProfiles directory for live sync

After running the script:

- Open iTerm2. If the profile is not automatically applied, go to Preferences > Profiles and select `Default`. You may need to restart iTerm2.

## Manual Installation (Advanced)

If you prefer to install manually, follow these steps:

1. Install Homebrew and all Brewfile dependencies:
   ```zsh
   brew bundle --file=~/dotfiles/Brewfile
   ```
2. Install Oh My Zsh:
   ```zsh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```
3. Install zsh-bat plugin:
   ```zsh
   git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
   ```
4. Symlink dotfiles:
   ```zsh
   ln -s ~/.dotfiles/.zshrc ~/.zshrc
   ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
   ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
   ```
5. Symlink iTerm2 profile:
   ```zsh
   mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
   ln -sf ~/.dotfiles/mac/com.googlecode.iterm2.plist "$HOME/Library/Application Support/iTerm2/DynamicProfiles/com.googlecode.iterm2.plist"
   ```

## Installation (Windows)

- Run the setup script for Windows:
  ```powershell
  cd ~/.dotfiles/windows
  ./setup-windows.sh
  ```
- (Planned) Add a winget bundle file to install dependencies automatically
- Add and configure your terminal settings as needed

## Folder Structure

- `mac/` — macOS-specific configuration and setup scripts
- `windows/` — Windows-specific configuration and setup scripts

## Todo for Mac

- [x] Add iTerm2 configuration (profile symlinked via setup script)

## Todo for Windows

- [ ] Add winget bundle file like Homebrew to install the same dependencies
- [ ] Add terminal configuration
