#1/usr/bin/env bash

[ $EUID -eq 0 ] && echo "[!] Please run as user!" && exit 1

dir=$(pwd)

install_apps="noto-fonts-cjk lazygit gcc cmake make fakeroot vim code discord steam lutris libreoffice-fresh qbittorrent"
yay_install_apps="google-chrome teams spotify"

echo "[*] detected desktop session: $DESKTOP_SESSION"

setup.sh # copied from https://github.com/endeavouros-team/endeavouros-i3wm-setup.git

# install some packages
echo "[*] installing pacman packages"
sudo pacman -Sq --noconfirm $install_apps

echo "[*] installing yay packages"
yay -Sq --noconfirm $yay_install_apps

# install Telegram
[[ ! -f /tmp/linux ]] && echo "[*] downloading Telegram" && wget -q --show-progress -P /tmp https://telegram.org/dl/desktop/linux

echo "[*] extracting Telegram"
sudo tar xf /tmp/linux --directory /opt --checkpoint=.200

echo "[*] adding Telegram to PATH"
sudo ln -s /opt/Telegram/Telegram /usr/bin/Telegram

# update all installed apps
sudo pacman -Sqyu --noconfirm

# adding printing/scanning scripts
echo "[*} adding printer scripts to PATH"
chmod +x scan
sudo ln -s $dir/scan /usr/bin/scan
sudo ln -s $dir/cvrt.py /usr/bin/cvrt.py

echo "[*] installing HP9DFFEC printer"
sudo systemctl start cups.service
sudo systemctl enable cups.service
hp-setup -i -a -x HP9DFFEC
hp-plugin -i

if [[ $DESKTOP_SESSION == i3 ]]; then
	echo "[*] setting up i3 desktop environment"
	install_apps="xclip ttf-iosevka-nerd xfce4-settings lxrandr"
	sudo pacman -Sq --noconfirm $install_apps

	# move own config files to ~/.config
	cp -rf .vimrc .config /home/$USER

	# setup monitors if more than one
	num_monitors=$(xrandr --listactivemonitors | head -n 1 | tr -d 'Monitors: ')
	echo "[*] number of monitors detected: $num_monitors"
	[[ $num_monitors -ge 2 ]] && lxrandr
fi

echo "[*] done!"
echo "[*] Please logout/reboot the system for all changes to take effect"
exit 0


