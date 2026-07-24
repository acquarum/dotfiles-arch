#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

dot_dir=$(realpath "$(dirname "$0")")

cd "$dot_dir"

main() {

	##########################
	### INSTALL MAIN TOOLS ###
	##########################

	# Create the symlinks to the configuration files
	stow .

	##### LY DISPLAY MANAGER #####
	sudo pacman --needed -Syu ly brightnessctl
	sudo systemctl disable kmsconvt@tty1.service
	sudo systemctl enable ly@tty1.service
	sudo mv /etc/ly/config.ini /etc/ly/config.ini.default
	sudo ln -s "$dot_dir/resources/ly/config.ini" /etc/ly/config.ini
	sudo sed -i "s/After=getty@%i.service/After=kmsconvt@%i.service/" /etc/systemd/system/multi-user.target.wants/ly@tty1.service
	sudo sed -i "s/Conflicts=getty@%i.service/Conflicts=kmsconvt@%i.service/" /etc/systemd/system/multi-user.target.wants/ly@tty1.service

	# Fonts
	sudo pacman --needed -S noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

	##### NIRI #####
	sudo pacman -S --needed niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
		gnome-keyring pipewire wireplumber wl-clipboard xdg-utils

	echo "
HandlePowerKey=suspend
HandlePowerKeyLongPress=poweroff
" | sudo tee /etc/systemd/logind.conf

	##### NOCTALIA SHELL #####
	sudo -S --needed libnotify
	paru -S noctalia-git

	##### ALACRITTY #####
	sudo pacman --needed -S alacritty

	##### CURSOR THEME #####
	sudo mkdir -p "/usr/share/icons/default"
	sudo tar -xJvf ./resources/themes/macOS.tar.xz -C "/usr/share/icons/"
	sudo rm "/usr/share/icons/LICENSE"
	echo "
[Icon Theme]
Inherits=macOS
" | sudo tee /usr/share/icons/default/index.theme

	##### ICON THEME #####
	sudo pacman -S --needed hicolor-icon-theme
	sudo pacman -S --needed papirus-icon-theme

	##### GTK THEME #####
	mkdir -p "$XDG_DATA_HOME/themes"
	tar -xJvf ./resources/themes/Nordic-darker.tar.xz -C "$XDG_DATA_HOME/themes/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/assets" "$XDG_CONFIG_HOME/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/gtk-4.0/gtk-dark.css" "$XDG_CONFIG_HOME/gtk-4.0/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/gtk-4.0/gtk.css" "$XDG_CONFIG_HOME/gtk-4.0/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/gtk-3.0/gtk-dark.css" "$XDG_CONFIG_HOME/gtk-3.0/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/gtk-3.0/gtk.css" "$XDG_CONFIG_HOME/gtk-3.0/"

	# Useful desktop apps
	sudo pacman -S --needed firefox

	##### PDF SUPPORT #####

	# Zathura
	sudo pacman -S --needed tesseract-data-eng tesseract-data-ita zathura zathura-pdf-mupdf

	# Texlive
	wget -P /tmp https://ctan.mirror.garr.it/mirrors/ctan/systems/texlive/tlnet/install-tl-unx.tar.gz
	destdir=$(tar xzvf /tmp/install-tl-unx.tar.gz -C /tmp | head -1 | sed -e 's/\/.*//')
	(cd "/tmp/$destdir" && ./install-tl -profile "$dot_dir/resources/texlive/texlive.profile")

	# Update locate db
	sudo updatedb
}

main "$@"
