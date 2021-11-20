#!/usr/bin/env bash

[ $EUID -eq 0 ] && echo "[!] Please do not run as root" && exit 1

dir=$(pwd)

installApps=("yay" "noto-fonts-cjk" "lazygit" "gcc" "cmake" "make" "fakeroot" "hplip" "cups" "vim" "code" "discord" "steam-manjaro" "lutris" "vlc" "libreoffice-fresh" "qbittorrent")
yayInstallApps=("google-chrome" "teams" "spotify")

echo "[*] detected desktop session: $DESKTOP_SESSION"

# install plugin in case of xfce desktop environment
if [ "$DESKTOP_SESSION" == 'xfce' ]; then
	installApps+=('xfce4-cpugraph-plugin' 'xfce4-cpufreq-plugin')
fi

# install pacman packages
echo "[*] installing pacman packages"
sudo pacman -Sq --noconfirm ${installApps[@]}

# install yay packages
echo "[*] installing yay packages"
yay -Sq ${yayInstallApps[@]}

# install Telegram
[[ ! -f /tmp/linux  ]] && echo "[*] downloading Telegram" && wget -q --show-progress -P /tmp https://telegram.org/dl/desktop/linux

echo "[*] extracting Telegram"
sudo tar xf /tmp/linux --directory /opt --checkpoint=.200
sudo ln -s /opt/Telegram/Telegram /usr/bin/Telegram

# update all installed apps
sudo pacman -Sqyu --noconfirm

echo "[*] adding printer scripts to PATH"
chmod +x scan
sudo ln -s $dir/scan /usr/bin/scan
sudo ln -s $dir/cvrt.py /usr/bin/cvrt.py

echo "[*] installing printer"
hp-setup -i -a -x HP9DFFEC
hp-plugin -i

# apparently i have to do this when on gnome
[[ $DESKTOP_SESSION == gnome ]] && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

if [[ $DESKTOP_SESSION == i3 ]]; then
    echo "[*] setting up i3 desktop environment"
    installApps=(light rofi dunst polybar alacritty xclip thunar scrot feh ttf-iosevka-nerd xfce4-settings mpd lxrandr)
    sudo pacman -Sq --noconfirm ${installApps[@]}

    yay -Sq i3lock-color

    # changing screen brightness is fun!
    sudo chmod +x /usr/bin/light

    # move dotfiles to $HOME
    echo "[*] moving configuration files to /home/$USER"
    cp -rf .vimrc .local .config /home/$USER

    # setup monitor config if more than one monitor
    num_monitors=$(xrandr --listactivemonitors | head -n 1 | tr -d 'Monitors: ')
    echo "[*] Numer of monitors detected: $num_monitors"
    [ $num_monitors -ge 2 ] && lxrandr
fi
    
echo "[*] Done!"
echo "[?] Do you wish to reboot? [Y]es/[N]o"
read askReboot
askReboot=$(echo $askReboot | tr '[:upper:]' '[:lower:]')
if [[ $askReboot == y ]] || [[ $askReboot == yes ]]; then
    reboot
fi

exit 0

