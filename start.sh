#!/bin/bash

# Initialize Homebrew if available
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Initialize rbenv if available
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init -)"
fi

# Check if setup has been run
if [ ! -f "backend/storage/development.sqlite3" ]; then
    echo "Database not found. Running setup first..."
    ./setup.sh
fi

# Function to kill process on port
kill_port() {
    local port=$1
    local pid=$(lsof -ti:$port)
    if [ ! -z "$pid" ]; then
        echo "Killing process on port $port (PID: $pid)"
        kill -9 $pid
    fi
}

# Kill any existing processes on our ports
kill_port 3000
kill_port 5173

# Start Rails server in background
echo "Starting Rails server on port 3000..."
cd backend && bundle exec puma -p 3000 &
RAILS_PID=$!

# Wait for Rails to start
sleep 3

# Start Vite dev server
echo "Starting Vite dev server on port 5173..."
cd frontend && npm run dev &
VITE_PID=$!

echo ""
echo "======================================"
echo "Thanx Rewards App is running!"
echo "======================================"
echo "Frontend: http://localhost:5173"
echo "Backend API: http://localhost:3000"
echo ""
echo "Test credentials:"
echo "  User: tong@gmail.com / user123"
echo "  Admin: admin@thanx.com / admin123"
echo ""
echo "Press Ctrl+C to stop both servers"
echo "======================================"

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "Stopping servers..."
    kill $RAILS_PID 2>/dev/null
    kill $VITE_PID 2>/dev/null
    exit 0
}

# Set up cleanup on SIGINT (Ctrl+C)
trap cleanup SIGINT

# Wait for both processes
wait $RAILS_PID $VITE_PID
