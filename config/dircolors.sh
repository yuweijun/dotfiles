#!/bin/bash

DIR=${DIR:-$(pwd)}

if [ ! -d "${DIR}/dircolors-solarized" ]; then
    git clone --depth=1 https://github.com/seebi/dircolors-solarized.git "${DIR}/dircolors-solarized"
fi

if [ -f $HOME/.dircolors ]; then
    echo "$HOME/.dircolors file exists"
else
    ln -sfn ${DIR}/dircolors-solarized/dircolors.256dark $HOME/.dircolors
fi

if [[ "$SHELL" =~ "zsh" ]]; then
    if [[ "$TERM" == "linux" ]]; then
        # for zsh on linux server
        ln -sfn ${DIR}/dircolors-solarized/dircolors.ansi-dark $HOME/.dircolors.linux
        echo "" >> ~/.zshrc
        echo 'eval "$(dircolors $HOME/.dircolors.linux)"' >> ~/.zshrc
    fi

    exit 0
fi

RCFILE=${RCFILE:-.bashrc}
if type dircolors > /dev/null 2>&1; then
    if ! grep dircolors ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo 'eval "$(SHELL=$SHELL dircolors $HOME/.dircolors)"' >> ${RCFILE}
    fi
elif type gdircolors > /dev/null 2>&1; then
    if ! grep gdircolors ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo 'eval "$(gdircolors $HOME/.dircolors)"' >> ${RCFILE}
    fi
else
    echo "" >> ${RCFILE}
    echo "export LS_COLORS='rs=0:di=01;33:ln=01;36:mh=00:pi=40;33'" >> ${RCFILE}
fi

