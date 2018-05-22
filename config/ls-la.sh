#!/bin/bash

if [[ "$SHELL" != */bin/bash* ]]; then
    exit 0
fi

if ! type ll > /dev/null 2>&1; then
    echo "" >> ${RCFILE}
    echo "alias ll='ls -alF'" >> $HOME/.bashrc
    echo "alias lt='ls -lt'" >> $HOME/.bashrc
    echo "alias ld='ls -ad'" >> $HOME/.bashrc
    echo "alias la='ls -A'" >> $HOME/.bashrc
    echo "alias l='ls -CF'" >> $HOME/.bashrc
fi

if ls --color -d . > /dev/null 2>&1; then
    echo "GNU's ls"
else
    if ! grep -q "alias lg" $HOME/.bashrc 2> /dev/null; then
        echo "alias lg='/bin/ls -laG'" >> $HOME/.bashrc
    fi
fi

