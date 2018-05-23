#!/bin/bash

if type brew 2> /dev/null; then
    if ! grep -q HOMEBREW_NO_AUTO_UPDATE ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo "[ \$((\$(date "+%S") % 5)) -eq 0 ] && export HOMEBREW_NO_AUTO_UPDATE=1" >> ${RCFILE}
    fi
fi
