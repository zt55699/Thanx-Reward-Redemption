#!/bin/bash

echo "Installing dependencies for Thanx Rewards App..."

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Install rbenv if not present
if ! command -v rbenv &> /dev/null; then
    echo "Installing rbenv..."
    brew install rbenv
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    eval "$(rbenv init -)"
fi

# Install Ruby 3.4.3 if not present
if ! rbenv versions | grep -q "3.4.3"; then
    echo "Installing Ruby 3.4.3..."
    rbenv install 3.4.3
    rbenv global 3.4.3
fi

# Install Node.js if not present
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    brew install node
fi

echo "All dependencies installed! Please restart your terminal or run:"
echo "  source ~/.bashrc"
echo "Then run ./setup.sh to set up the app."