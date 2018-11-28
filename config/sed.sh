#!/bin/bash

if [[ $OSTYPE =~ ^darwin ]]; then
    echo "" >> ${RCFILE}
    echo "# FIX sed on Mac OSX: RE error: illegal byte sequence" >> ${RCFILE}
    echo 'alias sed="LC_CTYPE=C sed"' >> ${RCFILE}
    echo "" >> ${RCFILE}
fi
