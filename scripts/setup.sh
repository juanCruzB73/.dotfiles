#!/bin/bash

# Ensure the script is run with sudo for package installation
if [ "$(id -u)" -ne "0" ]; then
    echo "THIS SCRIPT MUST RUN AS SUDO ADMIN"
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
apt install postgresql

# Install NVM
echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.bashrc

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
apt install i3-wm

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

exit
