#!/bin/bash

get_public_ip() {
    curl -s https://api.ipify.org
}

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing dependencies..."
brew install tiger-vnc python@3.9
brew install python-tk@3.9
brew install pipx


echo "Installing websockify..."
pipx install websockify

echo "Cloning noVNC repository..."
git clone https://github.com/vishvananda/novnc.git

echo "Fixing ImportError in websocket.py..."
sed -i '' 's/from cgi import parse_qsl/from urllib.parse import parse_qsl/g' noVNC/utils/websocket.py

echo "Generating self-signed certificate..."
cd noVNC
openssl req -x509 -nodes -newkey rsa:2048 -keyout self.pem -out self.pem -days 365

echo "Starting noVNC server..."
cd utils
./launch.sh --vnc localhost:5901 --listen 6080 &

echo ""
echo "Your public IP address:"
get_public_ip
echo ""

echo "noVNC is now running. Access it from your browser:"
echo "http://$(get_public_ip):6080/vnc.html"
echo ""
echo "Press Ctrl+C to stop the noVNC server."
