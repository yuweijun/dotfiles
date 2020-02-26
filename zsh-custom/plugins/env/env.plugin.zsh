# env setting for zsh

if [ -f $HOME/.envrc ]; then
    source $HOME/.envrc
fi

export LANG=en_US.UTF-8
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

export VIRTUAL_ENV_DISABLE_PROMPT=1
export PATH=$PATH:/usr/local/sbin:$HOME/bin

unsetopt BEEP

