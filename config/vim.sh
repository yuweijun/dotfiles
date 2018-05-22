#!/bin/bash

if [ ! -e $HOME/.vim ]; then
    ln -sfn ${DIR}/vim $HOME/.vim
    ln -sfn ${DIR}/bundle $HOME/.vim/bundle
    mkdir -p $HOME/.vim/tmp/backup $HOME/.vim/tmp/swap $HOME/.vim/tmp/undo
else
    echo ".vim folder exists"
fi

if [ ! -e $HOME/.vimrc ]; then
    ln -sfn ${DIR}/vim/terminal.vimrc $HOME/.vimrc
    ln -sfn ${DIR}/vim/linux.gvimrc $HOME/.gvimrc
else
    echo ".vimrc file exists"
fi

