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
config_dir="$HOME/.config"
aur_dir=$HOME/aur

zsh_dir="$config_dir/zsh"
alacritty_dir="$config_dir/alacritty"
git_dir="$config_dir/git"
tmux_dir="$config_dir/tmux"
nvim_dir="$config_dir/nvim"
vim_dir="$config_dir/vim"
hypr_dir="$config_dir/hypr"
yazi_dir="$config_dir/yazi"

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
	sudo pacman --needed -S timeshift

	# Create a BEFORE snapshot
	sudo timeshift --create --comment "Before configuration" --tags D

	# Install base packages
	sudo pacman --needed -S curl wget stow gzip unzip tar xz xz-utils make gcc openssh which locate \
		nftables networkmanager bluez bluez-utils base-devel man-db man-pages texinfo acpid \
		pipewire wireplumber wl-clipboard

	# Install useful packages
	sudo pacman --needed -S network-manager-applet blueman chromium nwg-look noto-fonts noto-fonts-cjk \
		noto-fonts-emoji noto-fonts-extra pacman-contrib

	sudo systemctl enable NetworkManager
	sudo systemctl enable sshd
	sudo systemctl enable bluetooth
	sudo systemctl enable acpid

	# Setup swap on zram
	sudo pacman --needed -S zram-generator
	echo "[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
mount-point = /dev/zram0
" | sudo tee /etc/systemd/zram-generator.conf
	systemctl daemon-reload
	systemctl start systemd-zram-setup@zram0.service

	mkdir -p "$XDG_BIN_HOME"

	##########################
	### INSTALL MAIN TOOLS ###
	##########################

	# Create the symlinks to the configuration files
	mkdir -p "$zsh_dir" "$alacritty_dir" "$git_dir" "$tmux_dir" \
		"$nvim_dir" "$vim_dir" "$hypr_dir" "$yazi_dir"
	stow .

	##### PARU AUR HELPER #####
	mkdir -p "$aur_dir"
	git clone https://aur.archlinux.org/paru.git --depth 1 "$aur_dir/paru"
	(cd "$aur_dir/paru" && makepkg -si)

	##### KMSCON #####
	sudo pacman --needed -S kmscon
	sudo systemctl disable getty@.service
	sudo systemctl enable kmsconvt@.service
	echo "hwaccel" | sudo tee /etc/kmscon/kmscon.conf

	##### LY DISPLAY MANAGER #####
	sudo pacman --needed -S ly brightnessctl
	sudo systemctl disable kmsconvt@tty1.service
	sudo systemctl enable ly@tty1.service
	sudo mv /etc/ly/config.ini /etc/ly/config.ini.default
	sudo ln -s "$dot_dir/resources/ly/config.ini" /etc/ly/config.ini

	##### GRUB THEME #####
	# unzip ./resources/grub-dark-matter.zip -d ./resources/grub-dark-matter
	# (cd ./resources/grub-dark-matter && sudo python3 darkmatter-theme.py -i)

	##### GTK THEME #####
	mkdir -p "$XDG_DATA_HOME/themes"
	tar -xJvf ./resources/Nordic-darker.tar.xz -C "$XDG_DATA_HOME/themes/"

	##### CURSOR THEME #####
	mkdir -p "$XDG_DATA_HOME/icons"
	tar -xJvf ./resources/macOS.tar.xz -C "$XDG_DATA_HOME/icons/"

	##### ICON THEME #####
	wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$XDG_DATA_HOME/icons" sh

	##### HYPRLAND #####
	sudo pacman --needed -S qt5-wayland qt6-wayland hyprland xdg-desktop-portal-hyprland \
		xdg-desktop-portal-gtk hyprpolkitagent hyprshot hyprshutdown hyprwcenter hyprsysteminfo \
		cliphist

	##### NOCTALIA #####
	paru -S noctalia-git

	##### UFW #####
	sudo pacman -S --needed ufw
	sudo systemctl enable ufw.service
	sudo ufw default deny incoming
	sudo ufw default allow outgoing
	sudo ufw allow ssh
	sudo ufw enable

	##### YAZI #####
	sudo pacman -S --needed yazi 7zip jq fd ripgrep fzf zoxide

	##### GIT #####
	ssh-keygen -t ed25519 -C "edoardo980@gmail.com" -f "$HOME/.ssh/id_ed25519" -N "" -q
	eval "$(ssh-agent)"
	ssh-add ~/.ssh/id_ed25519
	git remote set-url origin git@github.com:BlinDzOrE/dotfiles-arch.git

	##### ZSH #####
	sudo pacman --needed -S zsh

	# oh-my-zsh
	git clone https://github.com/ohmyzsh/ohmyzsh.git --depth 1 "${ohmyzsh_dir}"

	# Make zsh your login shell
	chsh -s "$(which zsh)"

	# powerlevel10k
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		"${ohmyzsh_themes}/powerlevel10k"

	# zsh-completions
	git clone https://github.com/zsh-users/zsh-completions.git --depth 1 \
		"${ohmyzsh_plugins}/zsh-completions"

	# zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions --depth 1 \
		"${ohmyzsh_plugins}/zsh-autosuggestions"

	# zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git --depth 1 \
		"${ohmyzsh_plugins}/zsh-syntax-highlighting"

	##### TMUX #####
	sudo pacman --needed -S tmux

	# Instal tpm (tmux-plugin-manager)
	mkdir "${tmux_dir}/plugins"
	git clone --depth 1 https://github.com/tmux-plugins/tpm "${tmux_dir}/plugins/tpm"
	bash -c "${tmux_dir}/plugins/tpm/bin/install_plugins"

	##### ALACRITTY #####
	sudo pacman --needed -S alacritty

	##### NEOVIM #####
	sudo pacman --needed -S nvim clang fd ripgrep tree-sitter-cli wl-clipboard ttf-jetbrains-mono-nerd \
		shellcheck shfmt bash-language-server lua-language-server stylua

	##### VIM #####
	sudo pacman --needed -S vim

	# Create an AFTER snapshot
	sudo timeshift --create --comment "After configuration" --tags D

	##### FINISH #####
	echo "Add this key to your GitHub account:"
	cat "$HOME/.ssh/id_ed25519.pub"
}

main "$@"
