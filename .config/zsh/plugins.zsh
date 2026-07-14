
### FUNCTIONS ###

_zplugin_install() {
	local plugin_path="${ZPLUGINSDIR}/${2}"
	if [[ ! -d "$plugin_path" ]]; then
		mkdir -p "$ZPLUGINSDIR"
		echo "Installing ${2}..."
		git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
			|| { echo "ERROR: failed to install ${2}" >&2; return 1; }
	fi
}

zplugin-update() {
	local dir
	for dir in "${ZPLUGINSDIR}"/*/; do
		echo "Updating ${dir:t}..."
		git -C "$dir" pull --ff-only
	done
}


### EXTERNAL PLUGINS ###

_zplugin_install romkatv powerlevel10k
source "$ZPLUGINSDIR/powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f "$ZDOTDIR/p10k.zsh" ]] || source "$ZDOTDIR/p10k.zsh" 

_zplugin_install zsh-users zsh-autosuggestions
source "$ZPLUGINSDIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"

_zplugin_install jeffreytse zsh-vi-mode
source $ZPLUGINSDIR/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Enable yanking to system clipboard and pasting with gp/gP
ZVM_SYSTEM_CLIPBOARD_ENABLED=true
# Always starting with insert mode for each command line
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

# zsh-vi-mode resets all bindings on init, so custom bindings
# must be registered via this hook to survive.
zvm_after_init() {
	bindkey '^Y' autosuggest-accept
}

_zplugin_install zsh-users zsh-completions
fpath+="$ZPLUGINSDIR/zsh-completions/src"


### COMPLETION ###
autoload -Uz compinit; compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Reuse ls completions for eza (avoids defining a separate completion function)
compdef eza=ls


# Load syntax highlighting last
_zplugin_install zsh-users zsh-syntax-highlighting
source "$ZPLUGINSDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"

