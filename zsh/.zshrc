# OH-MY-ZSH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# EDITOR
export EDITOR=nvim

# ALIASES
alias ll='ls -la'
alias gst='git status'
alias ga='git add'
alias gp='git push'
alias gco='git checkout'
alias g='git'
alias gb='git --no-pager branch'
alias gcm='git commit'

# COLORS
autoload -Uz colors && colors
setopt PROMPT_SUBST

# PROMPT 
PROMPT='%F{yellow}%n%f:%F{blue}%~%f $ '

# Terminal title
precmd() {
  print -Pn "\e]0;%n@%m: %~\a"
}

