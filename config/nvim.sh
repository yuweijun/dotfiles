#!/bin/bash

if [ ! -e ${HOME}/.config/nvim ]; then
    mkdir -p ${HOME}/.config/nvim
    mkdir -p ${HOME}/.local/share/nvim/tmp/backup ${HOME}/.local/share/nvim/tmp/swap ${HOME}/.local/share/nvim/tmp/undo
fi

if [ ! -e ${HOME}/.config/nvim/init.vim ]; then
    DIR=${DIR:-$(pwd)}

    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ln -sfn ${DIR}/vim/nvim.init.vim ${HOME}/.config/nvim/init.vim
fi

if type nvim &> /dev/null; then
    nvim +PlugInstall +qall
fi
