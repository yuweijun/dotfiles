#!/bin/bash

DIR=${DIR:-$(pwd)}

if [ ! -e $HOME/.vim ]; then
    ln -sfn ${DIR}/vim $HOME/.vim
else
    echo "$HOME/.vim folder exists"
fi

mkdir -p $HOME/.vim/tmp/backup $HOME/.vim/tmp/swap $HOME/.vim/tmp/undo

if [ ! -d ${DIR}/vim/bundle ]; then
    echo "git clone vundle"
    git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ${DIR}/vim/tmp/Vundle.vim
    git clone --depth=1 https://github.com/yuweijun/vundle.git ${DIR}/vim/bundle
    cd ${DIR}/vim/bundle
    git submodule update --init --recursive
    git submodule foreach git checkout master

    if type vim &> /dev/null; then
        vim +PluginInstall +qall
    fi
fi

if [ ! -e $HOME/.vimrc ]; then
    ln -sfn ${DIR}/vim/default.vimrc $HOME/.vimrc
    # ln -sfn ${DIR}/vim/linux.gvimrc $HOME/.gvimrc
    ln -sfn ${DIR}/vim/macosx.gvimrc $HOME/.gvimrc
    ln -sfn ${DIR}/vim/idea.vimrc $HOME/.ideavimrc
else
    echo ".vimrc file exists"
fi

