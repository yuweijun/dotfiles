#!/bin/bash

if [ ! -e $HOME/.autojump ]; then
    cd ${DIR}/autojump
    ./install.py
    cd -
fi

