#!/bin/bash

get_public_ip() {
    curl -s https://api.ipify.org
}

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing dependencies..."
brew install tiger-vnc python@3.9 npm
brew install pipx
npm install -g localtunnel

echo "Installing websockify..."
pipx install websockify

echo "Cloning noVNC repository..."
git clone https://github.com/vishvananda/novnc.git

echo "Fixing ImportError in websocket.py..."
sed -i '' 's/from cgi import parse_qsl/from urllib.parse import parse_qsl/g' noVNC/utils/websocket.py

# Install and start TigerVNC server
echo "Installing TigerVNC server..."
brew install tiger-vnc

echo "Starting TigerVNC server..."
vncserver :1 -geometry 1920x1080 -depth 24

echo ""
echo "Your public IP address:"
get_public_ip
echo ""

echo "Starting noVNC server..."
cd novnc/utils
./launch.sh --vnc localhost:5901 --listen 6080 &

echo "Starting localtunnel..."
lt --port 6080
