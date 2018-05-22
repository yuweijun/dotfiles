#!/bin/bash

if [ ! -f $HOME/.tmux.conf ]; then
    ln -sfn ${DIR}/tmux/tmux.linux.conf $HOME/.tmux.conf
fi

