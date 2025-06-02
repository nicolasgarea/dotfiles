export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export EDITOR=nano

#ALIAS
alias ll='ls -la'
alias gst='git status'
alias ga='git add'
alias gp='git push'
alias gco='git checkout'
alias g='git'
alias gb='git --no-pager branch'
