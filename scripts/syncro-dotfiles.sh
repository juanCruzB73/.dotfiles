#!/bin/bash


# Setting up VSCode dotfiles
echo "Setting up VSCode dotfiles..."
ln -sf ~/.dotfiles/.vscode/settings.json ~/.config/Code/User/settings.json

# Install VSCode extensions if extensions.json exists
if [ -f ~/.dotfiles/.vscode/extensions/extensions.json ]; then
    echo "Installing VSCode extensions..."
    while IFS= read -r extension; do
        code --install-extension "$extension"
    done < ~/.dotfiles/.vscode/extensions/extensions.json
else
    echo "No extensions.json found. Skipping extension installation."
fi

# Setting up dotfiles
echo "Setting up dotfiles..."
ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/.config/i3/config ~/.config/i3/config
