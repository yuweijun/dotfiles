#!/bin/bash

if [ ! -e $HOME/.autojump ]; then
    DIR=${DIR:-$(pwd)}

    cd ${DIR}/autojump
    export SHELL=/bin/bash
    ./install.py
    cd -
fi

