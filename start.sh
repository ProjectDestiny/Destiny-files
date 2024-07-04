#!/bin/bash

get_public_ip() {
    curl -s https://api.ipify.org
}

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing dependencies..."
brew install python@3.9 npm
brew install pipx
npm install -g localtunnel

echo "Installing websockify..."
pipx install websockify

echo "Cloning noVNC repository..."
git clone https://github.com/vishvananda/novnc.git

echo "Fixing ImportError in websocket.py..."
sed -i '' 's/from cgi import parse_qsl/from urllib.parse import parse_qsl/g' novnc/utils/websocket.py

# Install TigerVNC server using Homebrew
echo "Installing TigerVNC server..."
brew install tiger-vnc

# Start the TigerVNC server using the installed executable
echo "Starting TigerVNC server..."
$(brew --prefix)/Cellar/tiger-vnc/*/bin/vncserver :1 -geometry 1280x800 -depth 24 -localhost no -PasswordFile ~/.vnc/passwd

echo ""
echo "Your public IP address:"
get_public_ip
echo ""

echo "Starting noVNC server..."
cd novnc
openssl req -x509 -nodes -newkey rsa:2048 -keyout self.pem -out self.pem -days 365
cd utils
./launch.sh --vnc localhost:5901 --listen 6080 &

echo "Starting localtunnel..."
lt --port 6080
