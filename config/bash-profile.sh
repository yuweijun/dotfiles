#!/bin/bash

if [[ "$SHELL" != */bin/bash* ]]; then
    exit 0
fi

if [ -f $HOME/.bash_profile ]; then
    if grep -q .bashrc $HOME/.bash_profile 2> /dev/null; then
        echo ".bashrc config exists"
    else
        echo -e "\n####### add customize settings in ~/.bashrc #######" >> $HOME/.bash_profile
        echo "[ -f ~/.bashrc ] && source ~/.bashrc" >> $HOME/.bash_profile
    fi
fi

