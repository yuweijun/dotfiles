#!/bin/bash

if type brew 2> /dev/null; then
    ENVRC=${HOME}/.envrc

    if ! grep -q HOMEBREW_NO_AUTO_UPDATE ${ENVRC} 2> /dev/null; then
        echo "" >> ${ENVRC}
        echo "export HOMEBREW_NO_AUTO_UPDATE=1" >> ${ENVRC}
        echo eval "\"\$(/opt/homebrew/bin/brew shellenv)\"" >> ${ENVRC}
    fi
fi

