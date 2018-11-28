#!/bin/bash

if [ ! -e $HOME/.vim ]; then
    ln -sfn ${DIR}/vim $HOME/.vim
    mkdir -p $HOME/.vim/tmp/backup $HOME/.vim/tmp/swap $HOME/.vim/tmp/undo
else
    echo ".vim folder exists"
fi

if [ ! -d ${DIR}/vim/bundle ]; then
    echo "git clone vundle"
    git clone https://github.com/yuweijun/vundle.git ${DIR}/vim/bundle
    cd ${DIR}/vim/bundle
    git submodule update --init --recursive
fi

if [ ! -e $HOME/.vimrc ]; then
    ln -sfn ${DIR}/vim/terminal.vimrc $HOME/.vimrc
    ln -sfn ${DIR}/vim/linux.gvimrc $HOME/.gvimrc
else
    echo ".vimrc file exists"
fi

