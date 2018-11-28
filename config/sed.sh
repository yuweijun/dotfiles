#!/bin/bash

if [ $OSTYPE = 'darwin' ]; then
    # FIX sed on Mac OSX: RE error: illegal byte sequence
    echo 'alias sed="LC_CTYPE=C sed"' >> ${RCFILE}
    echo "" >> ${RCFILE}
fi
