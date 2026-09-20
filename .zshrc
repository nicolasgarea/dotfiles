export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export TERM="xterm-256color"
export ZSH="$HOME/.oh-my-zsh"

# Plugins
export ZPLUG_HOME="$HOME/.zplug"
if [ -f $ZPLUG_HOME/init.zsh ]; then
    source $ZPLUG_HOME/init.zsh
fi

# Async
zplug "mafredri/zsh-async", from:github

# Pure 
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

# Other plugins
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2
zplug "zsh-users/zsh-autosuggestions", as:plugin, defer:2

zplug load

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

ZSH_DISABLE_COMPFIX=true
autoload -Uz compinit
compinit

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

# GPG
export GPG_TTY=$(tty)

# asdf
export ASDF_DIR="$HOME/.asdf"
if [ -f $ASDF_DIR/asdf.sh ]; then
    . $ASDF_DIR/asdf.sh
    fpath=($ASDF_DIR/completions $fpath)
    autoload -Uz compinit
    compinit
fi

# NodeJS and Bun (React)
if command -v asdf >/dev/null 2>&1; then
    asdf global nodejs 24.8.0
    asdf global bun 1.0.14
fi

# Java (Spring)
if command -v asdf >/dev/null 2>&1; then
    asdf global java openjdk-21
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Load Angular CLI autocompletion.
source <(ng completion script)
