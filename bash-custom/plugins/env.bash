#!/bin/bash

export LANG=en_US.UTF-8

export VIRTUAL_ENV_DISABLE_PROMPT=1
export PATH=$PATH:/usr/local/sbin:$HOME/bin

if [[ $OSTYPE =~ ^darwin ]]; then
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
fi

if [ -f $HOME/.envrc ]; then
    source $HOME/.envrc
fi

