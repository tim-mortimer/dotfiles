#!/bin/sh

setup_homebrew() {
  if [ "$(uname -m)" = "x86_64" ]; then
    BREW_PATH="/usr/local/bin/brew"
  else
    BREW_PATH="/opt/homebrew/bin/brew"
  fi
  echo "eval \"\$($BREW_PATH shellenv)\"" >> "$HOME/.zprofile"
  eval "$($BREW_PATH shellenv)"
}

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  setup_homebrew 
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew bundle

# Create code directory
mkdir $HOME/code

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Hush login prompt
ln -s $HOME/.dotfiles/.hushlogin $HOME/.hushlogin

# Configure git
git config --global core.excludesfile ~/.dotfiles/.gitignore_global
git config --global core.autocrlf input
git config --global user.name "Tim Mortimer"
git config --global user.email tim@kiteframe.co.uk
