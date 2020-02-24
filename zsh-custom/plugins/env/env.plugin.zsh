# setup customization env of zsh
# ---------

if [ -f $HOME/.envrc ]; then
    source $HOME/.envrc
fi

unsetopt BEEP

export LANG=en_US.UTF-8
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PATH=$PATH:/usr/local/sbin:$HOME/bin

