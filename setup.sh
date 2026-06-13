#!/bin/bash

set -e

echo "Updating system..."
sudo apt update
sudo apt upgrade -y

echo "Installing development tools..."
sudo apt install -y \
    git \
    build-essential \
    gcc \
    g++ \
    make \
    curl \
    wget \
    vim

echo "Installing Apache..."
sudo apt install -y apache2

echo "Installing Python..."
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv

echo "Installing Ruby..."
sudo apt install -y \
    ruby-full \
    ruby-dev

echo "Installing PostgreSQL..."
sudo apt install -y \
    postgresql \
    postgresql-contrib \
    libpq-dev

echo "Installing Node.js and npm..."
sudo apt install -y nodejs npm

echo "Installing PHP..."
sudo apt install -y \
    php \
    php-cli \
    php-common \
    libapache2-mod-php

echo "Installing Rails..."
sudo gem install rails

echo "Installing Bootstrap (global npm package)..."
sudo npm install -g bootstrap

echo ""
echo "Installation complete!"
echo ""

echo "Versions:"
git --version
gcc --version | head -1
g++ --version | head -1
python3 --version
ruby --version
rails --version
psql --version
node --version
npm --version
php --version | head -1
