#!/bin/bash
get_public_ip() {
    curl -s https://api.ipify.org
}

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

sudo dscl . -create /Users/janke
sudo dscl . -create /Users/janke UserShell /bin/bash
sudo dscl . -create /Users/janke RealName Runner_Admin
sudo dscl . -create /Users/janke UniqueID 1001
sudo dscl . -create /Users/janke PrimaryGroupID 80
sudo dscl . -create /Users/janke NFSHomeDirectory /Users/tcv
sudo dscl . -passwd /Users/janke P@ssw0rd!
sudo dscl . -passwd /Users/janke P@ssw0rd!
sudo createhomedir -c -u janke > /dev/null
sudo dscl . -append /Groups/admin GroupMembership janke

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 
echo runnerrdp | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

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


echo ""
echo "Your public IP address:"
get_public_ip
echo ""

echo "Starting noVNC server..."
cd novnc
openssl req -x509 -nodes -newkey rsa:2048 -keyout self.pem -out self.pem -days 365
cd utils
./launch.sh --vnc localhost:5900 --listen 6080 &

echo "Starting localtunnel..."
lt --port 6080
