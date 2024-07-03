curl -s -o login.sh -L "https://github.com/ProjectDestiny/Destiny-files/edit/main/start.sh"
sudo mdutil -i off -a
echo "----------------- ADDING USER -----------------"
sudo useradd -m -s /bin/bash destiny && echo "destiny:password" | sudo chpasswd
sudo usermod -aG sudo destiny
cd ~
mkdir Moujira
echo "-----------------------------------------------"
echo "DONE!!"
echo "----------------- ALLOWING VNC -------------------"
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 
echo runnerrdp | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate
echo "--------------------------------------------------"
echo "DONE!!"
echo "------------------ IP ADDRESS ------------------"
curl ifconfig.co
echo "------------------------------------------------"
echo "*** REMEMBER THIS!! ***"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git
git --version
brew install tiger-vnc
vncserver :1
git clone https://github.com/novnc/noVNC.git
cd noVNC
sudo chmod +x launch.sh
./utils/launch.sh --vnc localhost:5901

