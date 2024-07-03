#!/bin/bash

# Function to retrieve public IP address
get_public_ip() {
    curl -s https://api.ipify.org
}

# Install Homebrew (if not already installed)
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install necessary packages using Homebrew
echo "Installing dependencies..."
brew install tiger-vnc openssl python@3.9

# Install websockify
echo "Installing websockify..."
pip3 install websockify

# Clone noVNC repository
echo "Cloning noVNC repository..."
git clone https://github.com/novnc/noVNC.git

# Fix for ImportError in websocket.py
echo "Fixing ImportError in websocket.py..."
sed -i '' 's/from cgi import parse_qsl/from urllib.parse import parse_qsl/g' noVNC/utils/websocket.py

# Generate self-signed certificate (optional but recommended)
echo "Generating self-signed certificate..."
cd noVNC
openssl req -x509 -nodes -newkey rsa:2048 -keyout self.pem -out self.pem -days 365

# Start noVNC server using websockify
echo "Starting noVNC server..."
./utils/launch.sh --vnc localhost:5901 --listen 6080 &

# Retrieve and display public IP address
echo ""
echo "Your public IP address:"
get_public_ip
echo ""

# Display connection information
echo "noVNC is now running. Access it from your browser:"
echo "http://$(get_public_ip):6080/vnc.html"
echo ""
echo "Press Ctrl+C to stop the noVNC server."
