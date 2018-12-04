#!/bin/bash

if [[ $OSTYPE =~ ^darwin ]]; then
    echo "" >> ${RCFILE}

    # FIX sed on Mac OSX: RE error: illegal byte sequence
    sed -i '' -E $'s#source "\$BASH_IT"/bash_it.sh#alias sed="LC_CTYPE=C sed"\\\n\\\nsource "\$BASH_IT"/bash_it.sh#' ${RCFILE}
fi
