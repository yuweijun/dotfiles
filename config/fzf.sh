#!/bin/bash

if [ ! -e $HOME/.fzf ]; then
    DIR=${DIR:-.}

    ln -sfn ${DIR}/fzf $HOME/.fzf
    ${HOME}/.fzf/install --no-bash --no-fish --no-zsh
fi

