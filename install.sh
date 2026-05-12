#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
	set -o xtrace
fi

cd "$(dirname "$0")"

# Install directories
config_dir="$HOME/.config"

zsh_dir="$config_dir/zsh"

ohmyzsh_dir="$zsh_dir/oh-my-zsh"
ohmyzsh_custom="$ohmyzsh_dir/custom"
ohmyzsh_themes="$ohmyzsh_custom/themes"
ohmyzsh_plugins="$ohmyzsh_custom/plugins"

alacritty_dir="$config_dir/alacritty"

git_dir="$config_dir/git"

tmux_dir="$config_dir/tmux"

nvim_dir="$config_dir/nvim"

main() {
	# Install base dependencies
	sudo pacman -S stow gzip tar xz make gcc openssh which

	# Create the symlinks to the configuration files
	mkdir -p "${zsh_dir}" "${alacritty_dir}" "${git_dir}" "${tmux_dir}" "${nvim_dir}"
	stow --adopt .

	##########################
	### INSTALL MAIN TOOLS ###
	##########################

	##### GIT #####

	sudo pacman -S git

	ssh-keygen -t ed25519 -C "edoardo980@gmail.com" -f "$HOME/.ssh/id_ed25519" -N "" -q
	eval "$(ssh-agent)"
	ssh-add ~/.ssh/id_ed25519

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


	##### FINISH #####
	echo "Add this key to your GitHub account:"
	cat "$HOME/.ssh/id_ed25519.pub"
}

main "$@"
