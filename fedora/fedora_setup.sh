#!/bin/env bash

dnf_pkgs="gnome-tweaks vim"
flatpak_pkgs="com.spotify.Client com.discordapp.Discord com.valvesoftware.Steam com.visualstudio.code org.gimp.GIMP org.qbittorrent.qBittorrent sh.ppy.osu"

# update the system
sudo dnf -y upgrade

# install google chrome
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf -y install google-chrome-stable


sudo dnf -y install $dnf_pkgs

# flatpak should be already installed but just in case
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install flatpak apps
flatpak -y install $flatpak_pkgs
