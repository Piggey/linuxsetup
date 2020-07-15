echo hi
sudo pacman -S snapd --noconfirm
sudo systemctl enable --now snapd.socket
sudo systemctl restart snapd.service

sudo pacman -S chromium --noconfirm
sudo pacman -R firefox --noconfirm

sudo pacman -S code --noconfirm
sudo pacman -S discord --noconfirm
sudo snap install spotify

sudo pacman -S steam-native --noconfirm
sudo pacman -S lutris --noconfirm

sudo pacman -S codeblocks --noconfirm
sudo pacman -S vlc --noconfirm
sudo pacman -S libreoffice-fresh --noconfirm
sudo pacman -S qbittorrent --noconfirm

sudo pacman -S jre8-openjdk --noconfirm
sudo pacman -S jdk8-openjdk --noconfirm

sudo pacman -Syu --noconfirm
echo bye
