#!/bin/bash

if [[ "$SHELL" != */bin/bash* ]]; then
    exit 0
fi

if type brew 2> /dev/null; then
    if ! grep -q HOMEBREW_NO_AUTO_UPDATE ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo "export HOMEBREW_NO_AUTO_UPDATE=1" >> ${RCFILE}
    fi
fi
