#!/bin/bash

set -ex

if type brew 2> /dev/null; then
    CUSTOMRC=${HOME}/.customrc

    if ! grep -q HOMEBREW_NO_AUTO_UPDATE ${CUSTOMRC} 2> /dev/null; then
        echo "" >> ${CUSTOMRC}
        echo "export HOMEBREW_NO_AUTO_UPDATE=1" >> ${CUSTOMRC}
    fi
fi

