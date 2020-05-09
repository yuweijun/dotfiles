# env setting for zsh

export LANG=en_US.UTF-8
export PATH=$PATH:/usr/local/sbin:$HOME/bin

HOMEBREW_NO_AUTO_UPDATE=1
VIRTUAL_ENV_DISABLE_PROMPT=1
USER_DISABLE_PROMPT=0
HOSTNAME_DISABLE_PROMPT=0
DISABLE_MAGIC_FUNCTIONS=true

unsetopt BEEP

if [[ $OSTYPE =~ ^darwin ]]; then
    CLICOLOR=1
    LSCOLORS=GxFxCxDxBxegedabagaced
fi

if [ -f $HOME/.envrc ]; then
    source $HOME/.envrc
fi

