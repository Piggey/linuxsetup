#!/usr/bin/env bash

[ $EUID -ne 0 ] && echo "Please run as root" && exit 1

installApps=("yay" "lazygit" "fakeroot" "hplip" "cups" "vim" "code" "discord" "steam-manjaro" "lutris" "vlc" "libreoffice-fresh" "qbittorrent")
removeApps=("firefox" "yakuake")
yayInstallApps=("google-chrome" "teams" "spotify")

echo "[*] detected desktop session: $DESKTOP_SESSION"

# install plugin in case of xfce desktop environment
[ $DESKTOP_SESSION -eq 'xfce' ] && $installApps+=("xfce4-cpugraph-plugin" "xfce4-cpufreq-plugin")

# install pacman packages
echo "[*] installing pacman packages"
pacman -Sq --noconfirm $installApps

# install yay packages
user=$(users)
su $user -c "yay -Sq $yayInstallApps --noconfirm"

# install Telegram
echo "[*] installing Telegram"
wget -q --show-progress -P /tmp https://telegram.org/dl/desktop/linux
echo "[*] extracting Telegram"
tar xf linux* --directory /opt --checkpoint=.200
ln -s /opt/Telegram/Telegram /usr/bin/Telegram

# remove some packages 
echo "[*] removing pacman packages"
pacman -R --noconfirm $removeApps

# update all installed apps
pacman -Sqyu --noconfirm

echo "[*] moving printer scripts to PATH"
mv cvrt.py scan /usr/bin/

echo "[*] installing printer"
hp-setup -i -a -x HP9DFFEC.home 
hp-plugin -i

# apparently i have to do this when on gnome
[ $DESKTOP_SESSION = 'gnome' ] && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

if [ $DESKTOP_SESSION = 'i3' ]; then
    echo "[*] setting up i3 desktop environment"
    installApps=(light dunst polybar alacritty xclip thunar scrot feh ttf-iosevka-nerd xfce4-settings mpd)
    pacman -Sq --noconfirm $installApps

    # move dotfiles to $HOME
    cp -rf .vimrc .local .config /home/$user
fi
    
    
echo "[*] done!"
exit 0
