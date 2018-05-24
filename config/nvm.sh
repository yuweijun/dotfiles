#!/bin/bash

if ! $SIMPLE; then
    if [ ! -d $HOME/.nvm ]; then
        ${DIR}/nvm/install.sh
    fi
fi
