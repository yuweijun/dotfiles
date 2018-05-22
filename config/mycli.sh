#!/bin/bash

if [ ! -f $HOME/.my.vim ]; then
    mkdir -p $HOME/.mysql/out
    ln -sfn ${DIR}/mycli/myclirc $HOME/.myclirc
    ln -sfn ${DIR}/mycli/my.cnf $HOME/.my.cnf
    ln -sfn ${DIR}/mycli/my.vim $HOME/.my.vim
fi
