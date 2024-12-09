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
if ! dpkg -l | grep -q postman; then
    echo "Installing Postman..."
    sudo snap install postman
else
    echo "Postman already installed."
fi

# Install i3 utilities
echo "Installing i3 utilities..."
apt install -y i3lock i3status dmenu

# Set up PostgreSQL
echo "Setting up PostgreSQL..."
sudo -u postgres psql -c "CREATE USER jcadmin WITH PASSWORD 'admin';"
sudo -u postgres psql -c "CREATE DATABASE mydb;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydb TO jcadmin"

echo "SET UP COMPLETE"
