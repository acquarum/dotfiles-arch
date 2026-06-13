# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$ZDOTDIR/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"


### OH-MY-ZSH CONFIG ###

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Remind me to update when it's time
zstyle ':omz:update' mode reminder


### USER CONFIGURATION ###

# History
HISTSIZE=2000
HISTFILE="$ZDOTDIR/zsh-history"
SAVEHIST=$HISTSIZE
HIST_STAMPS="yyyy-mm-dd"
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

### PLUGINS ###

# Edit command buffer (builtin)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

fpath+=$ZSH_CUSTOM/plugins/zsh-completions/src
autoload -Uz compinit && compinit

# Oh-My-Zsh plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/p10k.zsh ]] || source $ZDOTDIR/p10k.zsh


### ALIASES ###

alias ll="ls -lAhv --group-directories-first"
alias sunvim="sudoedit"
alias td="tmux new-session -A -s default"
alias tn="tmux new-session -A -s"

