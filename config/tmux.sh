#!/bin/bash

if [ ! -f $HOME/.tmux.conf ]; then
    DIR=${DIR:-.}

    ln -sfn ${DIR}/tmux/tmux.linux.conf $HOME/.tmux.conf
fi

