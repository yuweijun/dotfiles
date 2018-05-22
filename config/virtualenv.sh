#!/bin/bash

if type virtualenv > /dev/null 2>&1; then
    if type python3 2> /dev/null; then
        if [ ! -e $HOME/.virtualenv/python3 ]; then
            mkdir -p $HOME/.virtualenv/python3
            virtualenv -p $(which python3) $HOME/.virtualenv/python3
        fi
    elif type python2 2> /dev/null; then
        if [ ! -e $HOME/.virtualenv/python2 ]; then
            mkdir -p $HOME/.virtualenv/python2
            virtualenv -p $(which python2) $HOME/.virtualenv/python2
        fi
    fi

    if ! grep -q "bin/activate" ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        if type python3 2> /dev/null; then
            echo 'source $HOME/.virtualenv/python3/bin/activate' >> ${RCFILE}
        else
            echo 'source $HOME/.virtualenv/python2/bin/activate' >> ${RCFILE}
        fi
    fi
fi

