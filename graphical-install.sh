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
hypr_dir="$XDG_CONFIG_HOME/hypr"
gtk3_dir="$XDG_CONFIG_HOME/gtk-3.0"
gtk4_dir="$XDG_CONFIG_HOME/gtk-4.0"

main() {

	##########################
	### INSTALL MAIN TOOLS ###
	##########################

	# Create the symlinks to the configuration files
	mkdir -p "$alacritty_dir" "$hypr_dir" "$gtk3_dir" "$gtk4_dir"
	stow .

	##### LY DISPLAY MANAGER #####
	sudo pacman --needed -S ly brightnessctl
	sudo systemctl disable kmsconvt@tty1.service
	sudo systemctl enable ly@tty1.service
	sudo mv /etc/ly/config.ini /etc/ly/config.ini.default
	sudo ln -s "$dot_dir/resources/ly/config.ini" /etc/ly/config.ini

	##### HYPRLAND #####
	sudo pacman --needed -S pipewire wireplumber wl-clipboard qt5-wayland qt6-wayland hyprland xdg-desktop-portal-hyprland \
		xdg-desktop-portal-gtk hyprpolkitagent hyprshot hyprshutdown hyprwcenter hyprsysteminfo \
		cliphist

	##### NOCTALIA #####
	sudo pacman -S --needed meson gcc just \
		wayland wayland-protocols \
		libglvnd freetype2 fontconfig \
		cairo pango harfbuzz \
		libxkbcommon glib2 \
		sdbus-cpp libpipewire polkit \
		pam curl libwebp librsvg \
		libqalculate libxml2 \
		jemalloc
	paru -S noctalia-git

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
