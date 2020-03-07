#!/bin/bash

alias lt='ls -lat'
alias ll='ls -alF'
alias ld='ls -ad'
alias la='ls -A'
alias l='ls -aCF'

if type nvim > /dev/null 2>&1; then
    alias vim="nvim"
fi

alias vi="vim"
alias vbrc='vi ~/.bashrc'

if type gls > /dev/null 2>&1; then
    # gnu-ls command for Mac OS
    alias ls="gls --color=auto"
    # Mac OS ls original command
    alias lo="/bin/ls"
fi

if type exa > /dev/null 2>&1; then
    alias ext="exa -lTL 2"
fi

if type bat > /dev/null 2>&1; then
    alias cat="bat -p"
fi

if type systemctl > /dev/null 2>&1; then
    alias srvs='systemctl list-units --type=service --state=running'
fi


