# .dotfiles

This repository contains my personal dotfiles configuration.

## Overview

These dotfiles are used to maintain consistent development environments across different machines. They include configuration files for various tools and applications.

## Installation

Clone the repository

```bash
git clone https://github.com/username/.dotfiles.git ~/.dotfiles
```

Navigate into the dotfiles

```bash
cd ~/.dotfiles
```

Install all the brew applications

```bash
brew bundle
```

Install oh-my-zsh

```bash
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```

Install `zsh-bat`plugin

```bash
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
```

Extract dotfiles to the home directory

```bash
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
```

## Todo for Mac

- Add iterm2 configuration

## Todo for Windows

- Add winget bundle file like homebrew to install the same dependencies
- Add terminal configuration
