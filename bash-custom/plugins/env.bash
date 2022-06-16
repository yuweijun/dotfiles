#!/usr/bin/env bash

export TERM="xterm-256color"
export LANG=en_US.UTF-8
export PATH=$HOME/bin:$PATH

VIRTUAL_ENV_DISABLE_PROMPT=1
HOMEBREW_NO_AUTO_UPDATE=1

if [[ $OSTYPE =~ ^darwin ]]; then
    CLICOLOR=1
    LSCOLORS=GxFxCxDxBxegedabagaced
fi

