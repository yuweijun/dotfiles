#!/bin/bash

# set -x

if type nvim > /dev/null 2>&1; then
    if ! grep nvim ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo "alias vi='nvim'" >> ${RCFILE}
        echo "alias vim='nvim'" >> ${RCFILE}
        echo "alias vzrc='vi ~/.zshrc'" >> ${RCFILE}
    fi
fi

if [ ! -e ${HOME}/.config/nvim ]; then
    mkdir -p ${HOME}/.config/nvim
    mkdir -p ${HOME}/.local/share/nvim/tmp/backup ${HOME}/.local/share/nvim/tmp/swap ${HOME}/.local/share/nvim/tmp/undo
fi

if [ ! -e ${HOME}/.config/nvim/init.vim ]; then
    DIR=${DIR:-.}

    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ln -sfn ${DIR}/vim/nvim.init.vim ${HOME}/.config/nvim/init.vim
fi
