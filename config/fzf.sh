#!/bin/bash

DIR=${DIR:-$(pwd)}

if [ ! -d "${DIR}/fzf" ]; then
    git clone --depth=1 https://github.com/junegunn/fzf.git "${DIR}/fzf"
fi

if [ ! -e $HOME/.fzf ]; then
    ln -sfn ${DIR}/fzf $HOME/.fzf
fi

