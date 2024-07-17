# env setting for zsh

export LANG=en_US.UTF-8
export TERM="xterm-256color"
export PATH=$HOME/bin:$PATH

export HOMEBREW_NO_AUTO_UPDATE=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
USER_DISABLE_PROMPT=0
HOSTNAME_DISABLE_PROMPT=0
DISABLE_MAGIC_FUNCTIONS=true

unsetopt BEEP

if [[ $OSTYPE =~ ^darwin ]]; then
    CLICOLOR=1
    LSCOLORS=GxFxCxDxBxegedabagaced
fi

[ -f $HOME/.envrc ] && source $HOME/.envrc
