#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

dot_dir=$(realpath "$(dirname "$0")")

cd "$dot_dir"

# Device of the top level btrfs subvolume
btrfs_dev="/dev/nvme0n1p5"

# Install directories
config_dir="$HOME/.config"
aur_dir="$HOME/aur"
data_dir="$HOME/.local/share"

# Environmental variables
export XDG_CONFIG_HOME="$config_dir"
export XDG_DATA_HOME="$data_dir"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export INFOPATH="$HOME/.local/info"
manpath="$HOME/.local/man"

main() {

	############################
	### DEVICE CONFIGURATION ###
	############################

	# Configure snapper
	sudo pacman -Syu --needed snapper snap-pac inotify-tools arch-install-scripts
	sudo umount /.snapshots
	sudo rm -rf /.snapshots
	sudo snapper -c root create-config /
	sudo btrfs subvolume delete /.snapshots
	sudo mount --mkdir -o noatime,ssd,compress=zstd,space_cache=v2,discard=async,subvol=@snapshots $btrfs_dev /.snapshots
	sudo chmod 750 /.snapshots
	sudo mv /etc/snapper/configs/root /etc/snapper/configs/root.default
	sudo ln -s "$dot_dir/resources/snapper/root" /etc/snapper/configs/root
	sudo systemctl enable --now grub-btrfsd.service
	sudo systemctl enable --now snapper-timeline.timer
	sudo systemctl enable --now snapper-cleanup.timer 

	# Setup mirrors with reflector
	sudo pacman -S --needed reflector
	sudo reflector --protocol https --age 12 --latest 50 --fastest 10 --sort rate --save /etc/pacman.d/mirrorlist
	sudo mv /etc/xdg/reflector/reflector.conf /etc/xdg/reflector/reflector.conf.default
	sudo ln -s "$dot_dir/resources/reflector/reflector.conf" /etc/xdg/reflector/reflector.conf 
	sudo systemctl enable --now reflector.timer

	# Update mirror database
	sudo pacman -Syyu

	# Install important packages
	sudo pacman --needed -S curl wget stow gzip zip unzip tar xz make gcc locate \
		nftables bluez bluez-utils man-db man-pages texinfo upower pacman-contrib
	echo "PRUNENAMES = \".snapshots\"" | sudo tee /etc/updatedb.conf
	sudo systemctl enable --now bluetooth

	# Power management
	sudo pacman --needed -S tlp tlp-pd tlp-rdw
	sudo systemctl enable --now tlp.service
	sudo systemctl enable --now tlp-pd.service
	sudo systemctl enable NetworkManager-dispatcher.service
	sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket

	# Setup swap on zram
	sudo pacman --needed -S zram-generator
	echo "[zram0]
zram-size = min(ram / 2, 6144)
compression-algorithm = zstd
" | sudo tee /etc/systemd/zram-generator.conf
	sudo systemctl daemon-reload
	sudo systemctl start systemd-zram-setup@zram0.service
	sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="zswap.enabled=0"/' /etc/default/grub
	sudo grub-mkconfig -o /boot/grub/grub.cfg

	# Create directories
	mkdir -p "$XDG_BIN_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" \
		"$XDG_CACHE_HOME" "$XDG_STATE_HOME" "$aur_dir" "$manpath" "$INFOPATH"

	##########################
	### INSTALL MAIN TOOLS ###
	##########################

	# Create the symlinks to the configuration files
	stow --ignore='.config/alacritty' --ignore='.config/niri' --ignore='.config/gtk-3.0' \
		--ignore='.config/gtk-4.0' --ignore='.local' --ignore='.config/noctalia' --ignore='.config/zathura' .

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

	##### ZSH #####
	echo "
if [[ -z \"\$XDG_CONFIG_HOME\" ]]; then
	export XDG_CONFIG_HOME=\"\$HOME/.config\"
fi

if [[ -d \"\$XDG_CONFIG_HOME/zsh\" ]]; then
	export ZDOTDIR=\"\$XDG_CONFIG_HOME/zsh\"
fi
" | sudo tee /etc/zsh/zshenv

	mkdir -p "$XDG_CACHE_HOME/zsh" "$XDG_STATE_HOME/zsh" "$XDG_DATA_HOME/zsh/plugins"

	sudo pacman -S --needed fzf fd bat eza ripgrep

	##### TMUX #####
	sudo pacman --needed -S tmux
	mkdir "$XDG_DATA_HOME/tmux/plugins"

	##### NEOVIM #####
	sudo pacman --needed -S nvim clang fd ripgrep tree-sitter-cli ttf-jetbrains-mono-nerd \
		shellcheck shfmt bash-language-server lua-language-server stylua ty ruff

	# Python
	sudo pacman -S --needed uv

	##### GRUB THEME #####
	sudo mkdir -p /boot/grub/themes
	sudo unzip ./resources/themes/grub-dark-matter.zip -d /boot/grub/themes/ 
	echo GRUB_THEME=\"/boot/grub/themes/darkmatter/theme.txt\" | sudo tee -a /etc/default/grub 
	echo "
menuentry \"System restart\" --class restart {
	echo \"System rebooting...\"]
	reboot
}

menuentry \"System shutdown\" --class shutdown {
	echo \"System shutting down...\"
	halt
}
" | sudo tee -a /etc/grub.d/40_custom
	sudo grub-mkconfig -o /boot/grub/grub.cfg

	# Update locate database
	sudo updatedb
}

main "$@"
