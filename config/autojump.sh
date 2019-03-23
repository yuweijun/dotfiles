#!/bin/bash

if [ ! -e $HOME/.autojump ]; then
    DIR=${DIR:-.}

    cd ${DIR}/autojump
    export SHELL=/bin/bash
    ./install.py
    cd -
fi

