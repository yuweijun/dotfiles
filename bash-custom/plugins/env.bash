#!/bin/bash

LANG=en_US.UTF-8

VIRTUAL_ENV_DISABLE_PROMPT=1
HOMEBREW_NO_AUTO_UPDATE=1
PATH=$PATH:/usr/local/sbin:$HOME/bin

if [[ $OSTYPE =~ ^darwin ]]; then
    CLICOLOR=1
    LSCOLORS=GxFxCxDxBxegedabagaced
fi

