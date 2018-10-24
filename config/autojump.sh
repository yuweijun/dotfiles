#!/bin/bash

if [ ! -e $HOME/.autojump ]; then
    cd ${DIR}/autojump
    export SHELL=/bin/bash
    ./install.py
    cd -
fi

