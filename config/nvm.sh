#!/bin/bash

if ! $SIMPLE; then
    if [ ! -e $HOME/.nvm ]; then
        mkdir $HOME/.nvm
        ${DIR}/nvm/install.sh
    fi
fi
