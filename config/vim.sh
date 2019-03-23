#!/bin/bash

DIR=${DIR:-.}

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
    git submodule foreach git checkout master
else
    if type nvim > /dev/null 2>&1; then
        nvim +PlugInstall +qall
    else
        vim +PluginInstall +qall
    fi

    if type mvim > /dev/null 2>&1; then
        mvim +PluginInstall +qall
    fi
fi

if [ ! -e $HOME/.vimrc ]; then
    ln -sfn ${DIR}/vim/terminal.vimrc $HOME/.vimrc
    ln -sfn ${DIR}/vim/linux.gvimrc $HOME/.gvimrc
    ln -sfn ${DIR}/vim/idea.vimrc $HOME/.ideavimrc
else
    echo ".vimrc file exists"
fi

