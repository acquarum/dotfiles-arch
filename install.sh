#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

cd "$(dirname "$0")"

home_dir="/home/acquarum"

# Install directories
config_dir="$home_dir/.config"

zsh_dir="$config_dir/zsh"
alacritty_dir="$config_dir/alacritty"
git_dir="$config_dir/git"
tmux_dir="$config_dir/tmux"
nvim_dir="$config_dir/nvim"
vim_dir="$config_dir/vim"
hypr_dir="$config_dir/hypr"

ohmyzsh_dir="$zsh_dir/oh-my-zsh"
ohmyzsh_custom="$ohmyzsh_dir/custom"
ohmyzsh_themes="$ohmyzsh_custom/themes"
ohmyzsh_plugins="$ohmyzsh_custom/plugins"

# Environmental variables
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"

main() {

	############################
	### DEVICE CONFIGURATION ###
	############################

	# Install timeshift to create snapshots
	sudo pacman -S timeshift

	# Create a BEFORE snapshot
	sudo timeshift --create --comment "Before configuration" --tags D

	# Install base dependencies
	sudo pacman -S stow gzip tar xz make gcc openssh which pipewire \
		nftables bluez bluez-utils base-devel

	# Install useful packages
	sudo pacman -S networkmanager network-manager-applet \
		locate blueman  man-db man-pages \
		texinfo chromium acpid wireplumber wl-clipboard \
		xz-utils nwg-look noto-fonts noto-fonts-cjk noto-fonts-emoji \
		noto-fonts-extra pacman-contrib

	sudo systemctl enable NetworkManager
	sudo systemctl enable sshd
	sudo systemctl enable bluetooth
	sudo systemctl enable acpid

	# Setup swap on zram
	sudo pacman -S zram-generator
	echo "[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
mount-point = /dev/zram0
" | sudo tee /etc/systemd/zram-generator.conf
	systemctl daemon-reload
	systemctl start systemd-zram-setup@zram0.service

	##########################
	### INSTALL MAIN TOOLS ###
	##########################

	# Create the symlinks to the configuration files
	mkdir -p "${zsh_dir}" "${alacritty_dir}" "${git_dir}" "${tmux_dir}" \
		"${nvim_dir}" "${vim_dir}" "${hypr_dir}"
	stow .

	##### PARU AUR HELPER #####
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si

	##### SDDM DISPLAY MANAGER #####
	sudo pacman -S --needed \
		qt5-base sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg \
		sddm-kcm qt5-declarative
	sudo mkdir -p /usr/share/sddm/themes
	sudo tar -xzvf ./resources/sugar-candy.tar.gz -C /usr/share/sddm/themes
	sudo mkdir -p /etc/sddm.conf.d
	echo "[Theme]
Current=sugar-candy
" | sudo tee /etc/sddm.conf.d/sddm.conf
	sudo systemctl enable sddm.service


	##### GRUB THEME #####
	unzip ./resources/grub-dark-matter.zip -d ./resources/grub-dark-matter
	(cd ./resources/ && sudo python3 darkmatter-theme.py -i)

	##### GTK THEME #####
	mkdir -p ${home_dir}/.local/share/themes
	tar -xJvf ./resources/Nordic-darker.tar.xz -C "$XDG_DATA_HOME/themes/"

	##### CURSOR THEME #####
	mkdir -p "$XDG_DATA_HOME/icons"
	tar -xJvf ./resources/macOS.tar.xz -C "$XDG_DATA_HOME/icons/"

	##### ICON THEME #####
	wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$XDG_DATA_HOME/icons" sh

	##### HYPRLAND #####
	sudo pacman -S qt5-wayland qt6-wayland hyprland \
		xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
		hyprpolkitagent hyprshot hyprshutdown hyprwcenter hyprsysteminfo \
		cliphist

	##### NOCTALIA #####
	paru -S noctalia-git

	##### GIT #####
	ssh-keygen -t ed25519 -C "edoardo980@gmail.com" -f "$HOME/.ssh/id_ed25519" -N "" -q
	eval "$(ssh-agent)"
	ssh-add ~/.ssh/id_ed25519
	git remote set-url origin git@github.com:BlinDzOrE/dotfiles-arch.git

	##### ZSH #####
	sudo pacman -S zsh

	# oh-my-zsh
	git clone https://github.com/ohmyzsh/ohmyzsh.git "${ohmyzsh_dir}"

	# Make zsh your login shell
	chsh -s "$(which zsh)"

	# powerlevel10k
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		"${ohmyzsh_themes}/powerlevel10k"

	# zsh-completions
	git clone https://github.com/zsh-users/zsh-completions.git \
		"${ohmyzsh_plugins}/zsh-completions"

	# zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions \
		"${ohmyzsh_plugins}/zsh-autosuggestions"

	# zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		"${ohmyzsh_plugins}/zsh-syntax-highlighting"

	##### TMUX #####
	sudo pacman -S tmux

	# Instal tpm (tmux-plugin-manager)
	mkdir "${tmux_dir}/plugins"
	git clone https://github.com/tmux-plugins/tpm "${tmux_dir}/plugins/tpm"
	bash -c "${tmux_dir}/plugins/tpm/bin/install_plugins"

	##### ALACRITTY #####
	sudo pacman -S alacritty

	##### NEOVIM #####
	sudo pacman -S nvim clang fd ripgrep tree-sitter-cli wl-clipboard ttf-jetbrains-mono-nerd \
		shellcheck shfmt bash-language-server lua-language-server stylua

	##### VIM #####
	sudo pacman -S vim

	# Create an AFTER snapshot
	sudo timeshift --create --comment "After configuration" --tags D

	##### FINISH #####
	echo "Add this key to your GitHub account:"
	cat "$HOME/.ssh/id_ed25519.pub"
}

main "$@"
