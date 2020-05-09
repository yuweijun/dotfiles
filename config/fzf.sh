#!/bin/bash

if [ ! -d "${DIR}/fzf" ]; then
    git clone --depth=1 https://github.com/junegunn/fzf.git "${DIR}/fzf"
fi

if [ ! -e $HOME/.fzf ]; then
    DIR=${DIR:-$(pwd)}

    ln -sfn ${DIR}/fzf $HOME/.fzf
fi

