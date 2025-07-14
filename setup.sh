#!/bin/bash

echo "Setting up Thanx Rewards Redemption App..."

# Initialize Homebrew if available
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Initialize rbenv if available
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init -)"
fi

# Check if Ruby is installed
if ! command -v ruby &> /dev/null; then
    echo "Ruby is not installed. Please run ./install_deps.sh first."
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please run ./install_deps.sh first."
    exit 1
fi

# Backend setup
echo "Setting up Rails backend..."
cd backend

# Install bundler if not present
if ! gem list bundler -i > /dev/null 2>&1; then
    echo "Installing bundler..."
    gem install bundler
fi

# Install gems
echo "Installing Ruby gems..."
bundle install

# Create database and run migrations
echo "Setting up database..."
bundle exec rake db:create
bundle exec rake db:migrate

# Seed the database only if it's empty
if [ ! -s storage/development.sqlite3 ] || [ $(bundle exec rails runner "puts User.count") -eq 0 ]; then
    echo "Seeding database..."
    bundle exec rake db:seed
else
    echo "Database already contains data, skipping seed."
fi


cd ..

# Frontend setup
echo "Setting up React frontend..."
cd frontend

# Install npm packages
echo "Installing npm packages..."
npm install

cd ..


echo "Setup complete!"
echo ""
echo "To start the application, run:"
echo "  ./start.sh"
echo ""
echo "To run tests:"
echo "  Backend: cd backend && bundle exec rspec"
echo "  Frontend: cd frontend && npm test"
echo ""
