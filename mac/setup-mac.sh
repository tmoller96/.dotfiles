#!/usr/bin/env bash
# setup-mac.sh: Bootstrap your macOS development environment using your dotfiles
set -e

# Ask for sudo password upfront
echo "[+] Requesting sudo access..."
sudo -v

# Keep-alive: update existing `sudo` timestamp until script has finished
# (runs in background, stops when script ends)
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

DOTFILES_DIR="$HOME/.dotfiles"
BREWFILE="$DOTFILES_DIR/Brewfile"

# 1. Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "[+] Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "[+] Homebrew already installed."
fi

# Ensure brew is available in current shell
if [ -d "/opt/homebrew/bin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "[+] Installing Brewfile dependencies..."
brew bundle --file="$BREWFILE"

# 2. Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "[+] Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "[+] Oh My Zsh already installed."
fi

# 3. Install zsh-bat plugin if not present
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-bat" ]; then
  echo "[+] Installing zsh-bat plugin..."
  git clone https://github.com/fdellwing/zsh-bat.git "$ZSH_CUSTOM/plugins/zsh-bat"
else
  echo "[+] zsh-bat plugin already installed."
fi

# 4. Symlink dotfiles
for file in .zshrc .gitconfig .p10k.zsh; do
  src="$DOTFILES_DIR/$file"
  dest="$HOME/$file"
  if [ -e "$src" ]; then
    ln -sf "$src" "$dest"
    echo "[+] Symlinked $file"
  fi
done

# 5. Symlink iTerm2 profile for live sync
ITERM_PROFILE_SRC="$DOTFILES_DIR/mac/iterm2-profile.json"
ITERM_PROFILE_DEST="$HOME/Library/Application Support/iTerm2/DynamicProfiles/iterm2-profile.json"
if [ -e "$ITERM_PROFILE_SRC" ]; then
  mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  if [ -e "$ITERM_PROFILE_DEST" ] || [ -L "$ITERM_PROFILE_DEST" ]; then
    rm -f "$ITERM_PROFILE_DEST"
  fi
  ln -s "$ITERM_PROFILE_SRC" "$ITERM_PROFILE_DEST"
  echo "[+] Symlinked iTerm2 profile. Changes will sync with your repo."

  # Set the iTerm2 profile as default using AppleScript (not supported reliably)
  echo "[!] Automatic setting of default iTerm2 profile is not supported. Please set the default profile manually in iTerm2 > Preferences > Profiles."
else
  echo "[!] iTerm2 profile iterm2-profile.json not found in dotfiles."
fi

echo "[+] Setup complete! Please restart your terminal."
