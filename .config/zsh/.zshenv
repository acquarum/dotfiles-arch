
# ---------- XDG base directories ---------- #
if [[ -d "$HOME/.local/share" ]]; then; export XDG_DATA_HOME="$HOME/.local/share"; fi
if [[ -d "$HOME/.local/state" ]]; then; export XDG_STATE_HOME="$HOME/.local/state"; fi
if [[ -d "$HOME/.cache" ]]; then; export XDG_CACHE_HOME="$HOME/.cache"; fi
if [[ -d "$HOME/.local/bin" ]]; then
	export XDG_BIN_HOME="$HOME/.local/bin"
	path=($XDG_BIN_HOME ${path})
fi

typeset -U path

# ---------- Path to info manuals ---------- #
export -TU INFOPATH infopath 
if [[ -d "$HOME/.local/info" ]]; then; infopath=("$HOME/.local/info" $infopath); fi

# ---------- Path mouse cursors ---------- #
export -TU XCURSOR_PATH xcursor_path 
xcursor_path=("$XDG_DATA_HOME/icons" "/usr/local/share/icons" "/usr/share/icons" $xcursor_path)

# ---------- Editor ---------- #
export SUDO_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim

# ---------- For commit signing ---------- #
export GPG_TTY=$(tty)

# ---------- Zsh plugins dir ---------- #
if [[ -d "$HOME/.local/share/zsh/plugins" ]]; then; export ZPLUGINSDIR="$HOME/.local/share/zsh/plugins"; fi

