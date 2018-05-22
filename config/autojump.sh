#!/bin/bash

if [ ! -e $HOME/.autojump ]; then
    cd ${DIR}/autojump
    ./install.py
    cd -
fi

if type -a j > /dev/null 2>&1; then
    echo "j - autojump command exists"
else
    if [[ "$SHELL" = "/bin/zsh" ]]; then
        echo "autojump enabled by zsh plugins"
    else
        if ! grep -q autojump.bash ${RCFILE} 2> /dev/null; then
            echo "" >> ${RCFILE}
            echo "[ -f \$HOME/.autojump/share/autojump/autojump.bash ] && source \$HOME/.autojump/share/autojump/autojump.bash" >> ${RCFILE}
        fi
    fi
fi
