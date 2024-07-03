#Downloads
curl -s -o login.sh -L "https://github.com/ProjectDestiny/Destiny-files/edit/main/start.sh"
#disable spotlight indexing
sudo mdutil -i off -a
#Create new account
sudo useradd -m -s /bin/bash destiny && echo "destiny:password" | sudo chpasswd
sudo usermod -aG sudo destiny
cd ~
mkdir Moujira
#Fix
sudo /usr/sbin/systemsetup -getremotelogin
sudo /usr/sbin/systemsetup -setremotelogin on
#Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 
echo runnerrdp | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt
#Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate
#install brew
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install node
#verifying npm available
npm -v
#install localtunnel
curl https://loca.lt/mytunnelpassword
npm install -g localtunnel
lt --port 5090
#watermark
echo Script by the one and only MOUJIRAAAA!!!
