export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

# Plugins
export ZPLUG_HOME="$HOME/.zplug"
if [ -f $ZPLUG_HOME/init.zsh ]; then
    source $ZPLUG_HOME/init.zsh
fi

zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

zplug "plugins/git", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2
zplug "zsh-users/zsh-autosuggestions", as:plugin, defer:2

zplug load

ZSH_DISABLE_COMPFIX=true
autoload -Uz compinit
compinit -C

zstyle ':omz:update' mode auto
zstyle :omz:plugins:ssh-agent agent-forwarding on

if [ -f $ZSH/oh-my-zsh.sh ]; then
    source $ZSH/oh-my-zsh.sh
fi

# Alias
if [ -f $HOME/.aliases ]; then
    . $HOME/.aliases
fi

# Editor
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

export GPG_TTY=$(tty)

# nvm (lazy - loads on first use)
export NVM_DIR="$HOME/.nvm"
_load_nvm() {
    unset -f nvm node npm npx ng
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}
nvm() { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm() { _load_nvm; npm "$@"; }
npx() { _load_nvm; npx "$@"; }
ng() { _load_nvm; ng "$@"; }

# Angular CLI completion (cached)
_NG_CACHE="$HOME/.cache/zsh/ng-completion.zsh"
if [ -f "$_NG_CACHE" ]; then
    source "$_NG_CACHE"
fi
