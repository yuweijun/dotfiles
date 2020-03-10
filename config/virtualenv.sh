#!/bin/bash

if type pip > /dev/null 2>&1; then
    if ! type virtualenv > /dev/null 2>&1; then
        pip install virtualenv 2> /dev/null
    fi
fi

if type virtualenv > /dev/null 2>&1; then
    if type python3 2> /dev/null; then
        if [ ! -e ${HOME}/.virtualenv/python3 ]; then
            mkdir -p ${HOME}/.virtualenv/python3
            virtualenv -p $(which python3) ${HOME}/.virtualenv/python3
        fi
    elif type python2 2> /dev/null; then
        if [ ! -e ${HOME}/.virtualenv/python2 ]; then
            mkdir -p ${HOME}/.virtualenv/python2
            virtualenv -p $(which python2) ${HOME}/.virtualenv/python2
        fi
    fi

    RCFILE="${HOME}/.bashrc"
    if [ "${SHELL}" = "/bin/zsh" ]; then
        RCFILE="${HOME}/.zshrc"
    fi

    ENVRC="${HOME}/.envrc"
    if ! grep -q "bin/activate" ${ENVRC} 2> /dev/null; then
        echo "" >> ${ENVRC}
        if type python3 2> /dev/null; then
            echo 'source ${HOME}/.virtualenv/python3/bin/activate' >> ${ENVRC}
        else
            echo 'source ${HOME}/.virtualenv/python2/bin/activate' >> ${ENVRC}
        fi
    fi
fi

