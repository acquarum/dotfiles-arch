
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

typeset -U path

# set PATH so it includes user's private bin if it exists
if [[ -d $XDG_BIN_HOME ]] ; then
	path=($XDG_BIN_HOME ${path})
fi

