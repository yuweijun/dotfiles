#!/bin/bash

if type gls > /dev/null 2>&1; then
    if grep -q "alias lg" ${RCFILE} 2> /dev/null; then
        echo "alias lg exists"
    else
        echo "alias ls='gls --color=auto'" >> ${RCFILE}
        echo "alias lg='/bin/ls -laG'" >> ${RCFILE}
    fi

    if [ -n "$CLICOLOR" ]; then
        echo "CLICOLOR config exists"
    else
        echo "export CLICOLOR=1" >> ${RCFILE}
    fi

    if [ -n "$LSCOLORS" ]; then
        echo "LSCOLORS config exists"
    else
        echo "" >> ${RCFILE}
        echo "export LSCOLORS=GxFxCxDxBxegedabagaced" >> ${RCFILE}
    fi
fi
