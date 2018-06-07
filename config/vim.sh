#!/bin/bash

if [ ! -e $HOME/.vim ]; then
    ln -sfn ${DIR}/vim $HOME/.vim
    mkdir -p $HOME/.vim/tmp/backup $HOME/.vim/tmp/swap $HOME/.vim/tmp/undo
else
    echo ".vim folder exists"
fi

if [ ! -e $HOME/.vim/bundle ]; then
    ln -sfn ${DIR}/bundle $HOME/.vim/bundle
fi

if [ ! -e $HOME/.vimrc ]; then
    ln -sfn ${DIR}/vim/terminal.vimrc $HOME/.vimrc
    ln -sfn ${DIR}/vim/linux.gvimrc $HOME/.gvimrc
else
    echo ".vimrc file exists"
fi
