#!/bin/bash

DIR=${DIR:-.}

if [ -f $HOME/.dircolors ]; then
    echo "$HOME/.dircolors file exists"
else
    ln -sfn ${DIR}/dircolors-solarized/dircolors.256dark $HOME/.dircolors
fi

if [[ "$SHELL" != */bin/bash* ]]; then
    if [[ "$TERM" == "linux" ]]; then
        # for zsh on linux server
        ln -sfn ${DIR}/dircolors-solarized/dircolors.ansi-dark $HOME/.dircolors.linux
        echo "" >> ${RCFILE}
        echo 'eval "$(dircolors $HOME/.dircolors.linux)"' >> $HOME/.bashrc
    fi

    exit 0
fi

if type dircolors > /dev/null 2>&1; then
    if ! grep dircolors $HOME/.bashrc 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo 'eval "$(SHELL=$SHELL dircolors $HOME/.dircolors)"' >> $HOME/.bashrc
    fi
elif type gdircolors > /dev/null 2>&1; then
    if ! grep gdircolors $HOME/.bashrc 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo 'eval "$(gdircolors $HOME/.dircolors)"' >> $HOME/.bashrc
    fi
else
    echo "" >> ${RCFILE}
    echo "export LS_COLORS='rs=0:di=01;33:ln=01;36:mh=00:pi=40;33'" >> $HOME/.bashrc
fi

