#!/bin/env bash

# make the user provide printer ip address (to be later setup)
if [ $# -eq 0 ]; then 
	echo "[!] type printer ip address if you want to set it up, type skip if you want to skip setting the printer up"
	exit 1
fi

printer_ip=$1
dnf_pkgs="lazygit google-chrome-stable gnome-tweaks vim code discord lpf-spotify-client steam gimp qbittorrent"

# update the system
echo "[*] updating the system"
sudo dnf -y upgrade

## ADD ALL NEEDED REPOSITORIES
# google chrome
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome

# lazygit
sudo dnf copr enable atim/lazygit -y

# vscode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# discord, steam and spotify
sudo dnf -y install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# actually do the install
sudo dnf -y install $dnf_pkgs

# add scanning scripts to PATH
if [ $printer_ip != "skip" ]; then
	echo "[*] setting up the printer"
	sudo cp scan cvrt.py /usr/bin/

	# enable CUPS 
	sudo systemctl start cups.service
	sudo systemctl enable cups.service
	hp-setup -i -a -x $printer_ip
fi

echo "[*] done!"

