#!/bin/bash

curl -s -o login.sh -L "https://github.com/ProjectDestiny/Destiny-files/edit/main/start.sh"
sudo mdutil -i off -a
sudo useradd -m -s /bin/bash destiny && echo "destiny:password" | sudo chpasswd
sudo usermod -aG sudo destiny
cd ~
mkdir Moujira

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 
echo runnerrdp | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

get_public_ip() {
    curl -s https://api.ipify.org
}

if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install tigervnc openssl python@3.9

pip3 install websockify

git clone https://github.com/vishvananda/novnc.git

cd noVNC
openssl req -x509 -nodes -newkey rsa:2048 -keyout self.pem -out self.pem -days 365

./utils/launch.sh --vnc localhost:5901 --listen 6080 &

echo ""
echo "Your public IP address:"
get_public_ip
echo ""

echo "noVNC is now running. Access it from your browser:"
echo "http://$(get_public_ip):6080/vnc.html"
echo ""
echo "Press Ctrl+C to stop the noVNC server."
