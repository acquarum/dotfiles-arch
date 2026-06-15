#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

dot_dir=$(realpath "$(dirname "$0")")

cd "$dot_dir"

# Install directories
alacritty_dir="$XDG_CONFIG_HOME/alacritty"
niri_dir="$XDG_CONFIG_HOME/niri"
gtk3_dir="$XDG_CONFIG_HOME/gtk-3.0"
gtk4_dir="$XDG_CONFIG_HOME/gtk-4.0"

main() {

	##########################
	### INSTALL MAIN TOOLS ###
	##########################

	# Create the symlinks to the configuration files
	mkdir -p "$alacritty_dir" "$niri_dir" "$gtk3_dir" "$gtk4_dir"
	stow .

	##### LY DISPLAY MANAGER #####
	sudo pacman --needed -S ly brightnessctl
	sudo systemctl disable kmsconvt@tty1.service
	sudo systemctl enable ly@tty1.service
	sudo mv /etc/ly/config.ini /etc/ly/config.ini.default
	sudo ln -s "$dot_dir/resources/ly/config.ini" /etc/ly/config.ini

	##### NIRI #####
	sudo pacman -S --needed niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
		gnome-keyring pipewire wireplumber wl-clipboard

	##### DMS SHELL #####
	sudo pacman -S --needed quickshell dms-shell-niri cava qt6-multimedia-ffmpeg cliphist \
		dgop dsearch
	systemctl --user add-wants niri.service dms

	##### ALACRITTY #####
	sudo pacman --needed -S alacritty

	##### CURSOR THEME #####
	mkdir -p "$XDG_DATA_HOME/icons"
	tar -xJvf ./resources/macOS.tar.xz -C "$XDG_DATA_HOME/icons/"
	rm "$XDG_DATA_HOME/icons/LICENSE"
	ln -s "$XDG_DATA_HOME/icons/macOS" "$XDG_DATA_HOME/icons/default"

	##### ICON THEME #####
	sudo pacman -S --needed hicolor-icon-theme
	sudo pacman -S --needed papirus-icon-theme

	##### GTK THEME #####
	mkdir -p "$XDG_DATA_HOME/themes"
	tar -xJvf ./resources/Nordic-darker.tar.xz -C "$XDG_DATA_HOME/themes/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/assets" "$XDG_CONFIG_HOME/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/gtk-4.0/gtk-dark.css" "$XDG_CONFIG_HOME/gtk-4.0/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/gtk-4.0/gtk.css" "$XDG_CONFIG_HOME/gtk-4.0/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/gtk-3.0/gtk-dark.css" "$XDG_CONFIG_HOME/gtk-3.0/"
	ln -s "$XDG_DATA_HOME/themes/Nordic-darker-v40/gtk-3.0/gtk.css" "$XDG_CONFIG_HOME/gtk-3.0/"
}

main "$@"
