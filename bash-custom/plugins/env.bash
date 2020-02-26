#!/bin/bash

if [ -f $HOME/.envrc ]; then
    source $HOME/.envrc
fi

export LANG=en_US.UTF-8
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PATH=$PATH:/usr/local/sbin:$HOME/bin

if type gls > /dev/null 2>&1; then
    if [ -n "$CLICOLOR" ]; then
        echo "CLICOLOR config exists"
    else
        echo "export CLICOLOR=1" >> ${RCFILE}
    fi

    if [ -n "$LSCOLORS" ]; then
        echo "LSCOLORS config exists"
    else
        echo "" >> ${RCFILE}
        echo "export LSCOLORS=GxFxCxDxBxegedabagaced" >> ${RCFILE}
    fi
fi
