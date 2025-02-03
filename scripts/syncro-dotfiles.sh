#!/bin/bash

# Setting up VSCode dotfiles
echo "Setting up VSCode dotfiles..."
ln -sf ~/.dotfiles/.vscode/settings.json ~/.config/Code/User/settings.json#

# Setting up dotfiles
echo "Setting up dotfiles..."

echo "Setting up gitconfig"
ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
echo "Setting up i3"
ln -sf ~/.dotfiles/.config/i3/config ~/.config/i3/config
echo "Setting up .bashrc"
ln -sf ~/.dotfiles/.bashrc ~/.bashrc

