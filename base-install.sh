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
aur_dir="$HOME/aur"
data_dir="$HOME/.local/share"

zsh_dir="$config_dir/zsh"
git_dir="$config_dir/git"
tmux_dir="$config_dir/tmux"
nvim_dir="$config_dir/nvim"
yazi_dir="$config_dir/yazi"

ohmyzsh_dir="$zsh_dir/oh-my-zsh"
ohmyzsh_custom="$ohmyzsh_dir/custom"
ohmyzsh_themes="$ohmyzsh_custom/themes"
ohmyzsh_plugins="$ohmyzsh_custom/plugins"

# Environmental variables
export XDG_CONFIG_HOME="$config_dir"
export XDG_DATA_HOME="$data_dir"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"

main() {

	############################
	### DEVICE CONFIGURATION ###
	############################

	# Install base packages
	sudo pacman --needed -S curl wget stow gzip zip unzip tar xz make gcc locate \
		nftables bluez bluez-utils man-db man-pages texinfo acpid

	# Install useful packages
	sudo pacman --needed -S noto-fonts noto-fonts-cjk noto-fonts-emoji \
		noto-fonts-extra pacman-contrib

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
	sudo systemctl daemon-reload
	sudo systemctl start systemd-zram-setup@zram0.service

	# Create directories
	mkdir -p "$XDG_BIN_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" \
		"$XDG_CACHE_HOME" "$XDG_STATE_HOME" "$aur_dir"

	##########################
	### INSTALL MAIN TOOLS ###
	##########################

	# Create the symlinks to the configuration files
	mkdir -p "$zsh_dir" "$git_dir" "$tmux_dir" "$nvim_dir" "$yazi_dir"
	stow --ignore='.config/alacritty' --ignore='.config/hypr' --ignore='.config/gtk-3.0' \
		--ignore='.config/gtk-4.0' --ignore='.config/noctalia' .

	##### PARU AUR HELPER #####
	git clone https://aur.archlinux.org/paru.git --depth 1 "$aur_dir/paru"
	(cd "$aur_dir/paru" && makepkg -si)

	##### KMSCON #####
	sudo pacman --needed -S kmscon
	sudo systemctl disable getty@.service
	sudo systemctl enable kmsconvt@.service
	echo "hwaccel" | sudo tee /etc/kmscon/kmscon.conf

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

	# oh-my-zsh
	git clone https://github.com/ohmyzsh/ohmyzsh.git --depth 1 "$ohmyzsh_dir"

	# powerlevel10k
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
		"$ohmyzsh_themes/powerlevel10k"

	# zsh-completions
	git clone https://github.com/zsh-users/zsh-completions.git --depth 1 \
		"$ohmyzsh_plugins/zsh-completions"

	# zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions --depth 1 \
		"$ohmyzsh_plugins/zsh-autosuggestions"

	# zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git --depth 1 \
		"$ohmyzsh_plugins/zsh-syntax-highlighting"

	##### TMUX #####
	sudo pacman --needed -S tmux

	# Instal tpm (tmux-plugin-manager)
	mkdir "$tmux_dir/plugins"
	git clone --depth 1 https://github.com/tmux-plugins/tpm "$tmux_dir/plugins/tpm"
	bash -c "$tmux_dir/plugins/tpm/bin/install_plugins"

	##### NEOVIM #####
	sudo pacman --needed -S nvim clang fd ripgrep tree-sitter-cli wl-clipboard ttf-jetbrains-mono-nerd \
		shellcheck shfmt bash-language-server lua-language-server stylua

	##### GRUB THEME #####
	unzip ./resources/grub-dark-matter.zip -d /tmp/grub-dark-matter
	sudo mkdir -p /boot/grub/themes
	sudo mv /tmp/grub-dark-matter/darkmatter /boot/grub/themes/
	echo GRUB_THEME=\"/boot/grub/themes/darkmatter/theme.txt\" | sudo tee -a /etc/default/grub 
	sudo grub-mkconfig -o /boot/grub/grub.cfg

	##### FINISH #####
	echo "Add this key to your GitHub account:"
	cat "$HOME/.ssh/id_ed25519.pub"
}

main "$@"
