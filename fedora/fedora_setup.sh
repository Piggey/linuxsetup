#!/bin/env bash

# make the user provide printer ip address (to be later setup)
if [ $# -eq 0 ]; then 
	echo "[!] type printer ip address if you want to set it up, type skip if you want to skip setting the printer up"
	exit 1
fi

printer_ip=$1
dnf_pkgs="gnome-tweaks vim"
flatpak_pkgs="com.spotify.Client com.discordapp.Discord com.valvesoftware.Steam com.visualstudio.code org.gimp.GIMP org.qbittorrent.qBittorrent sh.ppy.osu"

# update the system
echo "[*] updating the system"
sudo dnf -y upgrade

# install google chrome
echo "[*] installing Google Chrome"
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf -y install google-chrome-stable

# install lazygit
echo "[*] installing the rest of the very cool packages I need!"
sudo dnf copr enable atim/lazygit -y
sudo dnf -y install lazygit

sudo dnf -y install $dnf_pkgs

# flatpak should be already installed but just in case
echo "[*] install some cool flatpak packages"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install flatpak apps
flatpak -y install $flatpak_pkgs

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

