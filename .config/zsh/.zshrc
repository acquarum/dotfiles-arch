# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History
HISTSIZE=5000
HISTFILE="$XDG_STATE_HOME/zsh/history"
SAVEHIST=$HISTSIZE
HIST_STAMPS="yyyy-mm-dd"
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Shell behaviour
setopt nobeep
setopt numeric_glob_sort

# Fzf
source "$ZDOTDIR/fzf.zsh"

# Aliases
source "$ZDOTDIR/aliases.zsh"

# Plugins
source "$ZDOTDIR/plugins.zsh"

