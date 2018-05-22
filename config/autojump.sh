#!/bin/bash

if ! type j > /dev/null 2>&1; then
    cd ${DIR}/autojump
    ./install.py
    cd -
fi

