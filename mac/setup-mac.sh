#!/usr/bin/env bash
# setup-mac.sh: Bootstrap your macOS development environment using your dotfiles
set -e

DOTFILES_DIR="$HOME/.dotfiles"
BREWFILE="$DOTFILES_DIR/Brewfile"

# 1. Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "[+] Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "[+] Homebrew already installed."
  eval "$(/opt/homebrew/bin/brew shellenv)"
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

# 5. Configure iTerm2 to load preferences from dotfiles
ITERM_PREFS_DIR="$DOTFILES_DIR/mac"
echo "[+] Configuring iTerm2 to load preferences from $ITERM_PREFS_DIR ..."
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$ITERM_PREFS_DIR"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 SavePrefsOnExit -bool true
echo "[+] iTerm2 is now set to load preferences from $ITERM_PREFS_DIR. Please restart iTerm2 for changes to take effect."

echo "[+] Setup complete! Please restart your terminal."

# 6. Open iTerm2 and close the current terminal
if command -v open &>/dev/null; then
  echo "[+] Opening iTerm2..."
  open -a iTerm
  # Close the current terminal window (works for Terminal.app and iTerm2 launched from Terminal)
  osascript -e 'tell application "Terminal" to close (every window whose visible is true)' 2>/dev/null || true
  osascript -e 'tell application "iTerm" to tell current window to close if exists' 2>/dev/null || true
fi
