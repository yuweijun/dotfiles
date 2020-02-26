#!/bin/bash

if type gls > /dev/null 2>&1; then
    if grep -q "alias lg" ${RCFILE} 2> /dev/null; then
        echo "alias lg exists"
    else
        echo "alias ls='gls --color=auto'" >> ${RCFILE}
        echo "alias lg='/bin/ls -laG'" >> ${RCFILE}
    fi
fi
