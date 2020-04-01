#!/bin/bash

if [ ! -e ${HOME}/.config/nvim ]; then
    mkdir -p ${HOME}/.config/nvim
    mkdir -p ${HOME}/.local/share/nvim/tmp/backup ${HOME}/.local/share/nvim/tmp/swap ${HOME}/.local/share/nvim/tmp/undo
fi

if [ ! -e ${HOME}/.vim/tmp/plug.vim ]; then
    DIR=${DIR:-$(pwd)}
    if [ ! -e $HOME/.vim ]; then
        ln -sfn ${DIR}/vim $HOME/.vim
    fi

    ln -sfn ${DIR}/vim/nvim.init.vim ${HOME}/.config/nvim/init.vim
    curl -fLo ${HOME}/.vim/tmp/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if type nvim &> /dev/null; then
    nvim +PlugInstall +qall
fi
