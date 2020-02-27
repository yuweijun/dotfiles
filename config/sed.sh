#!/bin/bash

if [[ $OSTYPE =~ ^darwin ]]; then
    echo >> ${RCFILE}
    echo '# FIX sed on Mac OSX 10.7: RE error: illegal byte sequence' >> ${RCFILE}
    echo 'alias sed="LC_CTYPE=C sed"' >> ${RCFILE}
fi

