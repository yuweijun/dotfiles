#!/bin/bash

# ubuntu install pip3/pip/virtualenv
# apt install -y python3-pip
# or
# apt install -y python-pip
# or
# apt install -y python3-virtualenv
#
# Alpine Linux
# apk install python3 py3-pip

if type pip > /dev/null 2>&1; then
    if ! type virtualenv > /dev/null 2>&1; then
        pip install virtualenv 2> /dev/null
    fi
elif type pip3 > /dev/null 2>&1; then
    if ! type virtualenv > /dev/null 2>&1; then
        pip3 install virtualenv 2> /dev/null
    fi
else
    exit 0
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
    elif type python 2> /dev/null; then
        if [ ! -e ${HOME}/.virtualenv/python ]; then
            mkdir -p ${HOME}/.virtualenv/python
            virtualenv -p $(which python) ${HOME}/.virtualenv/python
        fi
    fi

    RCFILE="${HOME}/.bashrc"
    if [[ "${SHELL}" =~ "zsh" ]]; then
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

if [ -e /usr/local/opt/python/bin/pip3 ]; then
    # reinstall virtualenv after upgrade python and pip3
    /usr/local/opt/python/bin/pip3 install virtualenv
    # virtualenv -p $(which python3) ${HOME}/.virtualenv/python3
fi

