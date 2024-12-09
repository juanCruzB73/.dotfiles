#!/bin/bash

# Ensure the script is run with sudo for package installation
if [ "$(id -u)" -ne "0" ]; then
    echo "THIS SCRIPT MUST RUN AS SUDO ADMIN"
    exit 1
fi

# Ensure .dotfiles directory exists
if [ ! -d ~/.dotfiles ]; then
    echo "~/.dotfiles directory does not exist!"
    exit 1
fi

# Update package list
echo "Updating packages..."
apt update -y

# Install common dependencies
echo "Installing common packages..."
apt install -y curl wget git unzip build-essential

# Install OpenJDK
echo "Installing JDK..."
apt install -y openjdk-17-jdk

# Install PostgreSQL
echo "Installing PostgreSQL..."
apt install -y postgresql postgresql-contrib

# Install NVM
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Install Node.js
echo "Installing Node.js..."
nvm install node

# Install Postman if not already installed
if ! snap list | grep -q postman; then
    echo "Installing Postman..."
    sudo snap install postman
else
    echo "Postman already installed."
fi

# Install i3 utilities
echo "Installing i3 utilities..."
apt install -y i3lock i3status dmenu

# Install Visual Studio Code if not already installed
if ! command -v code &> /dev/null; then
    echo "Installing Visual Studio Code..."
    sudo snap install --classic code
    if ! command -v code &> /dev/null; then
        echo "VS Code installation failed."
        exit 1
    fi
else
    echo "VS Code already installed."
fi

# Set up PostgreSQL
echo "Setting up PostgreSQL..."
sudo -u postgres psql -c "DO \$(echo \"SELECT 1 FROM pg_roles WHERE rolname='jcadmin' LIMIT 1\") IS NULL DO CREATE USER jcadmin WITH PASSWORD 'admin';"
sudo -u postgres psql -c "DO \$(echo \"SELECT 1 FROM pg_database WHERE datname='mydb' LIMIT 1\") IS NULL DO CREATE DATABASE mydb;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydb TO jcadmin"

# Setting up VSCode dotfiles
echo "Setting up VSCode dotfiles..."
ln -sf ~/.dotfiles/.vscode/settings.json ~/.config/Code/User/settings.json
ln -sf ~/.dotfiles/.vscode/keybindings.json ~/.config/Code/User/keybindings.json

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
if [ -f ~/.dotfiles/.gitconfig ]; then
    ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig
else
    echo ".gitconfig not found in ~/.dotfiles."
fi
if [ -f ~/.dotfiles/.config/i3/config ]; then
    ln -sf ~/.dotfiles/.config/i3/config ~/.config/i3/config
else
    echo "i3 config not f
