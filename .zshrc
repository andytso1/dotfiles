# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme

ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# allow cap-insensitive auto complete
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# environment variables
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias sl='ls'
alias ll='ls -lah'
alias mv='mv -i'
alias dc='cd'
alias szrc='source ~/.zshrc'
alias jupylab='jupyter-lab'

alias gs='git status'
alias gb='git branch'
alias gd='git diff'

alias tns='tmux new-session -s'
alias tls='tmux ls'
alias tat='tmux a -t'

# enable vim bindings in zsh 
bindkey -v '^?' backward-delete-char

# enable colors in tmux 
export TERM=xterm-256color

# enable '#' comments
setopt interactive_comments

# add syntax highlighting
source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/usr/local/opt/ruby/bin:$PATH"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
