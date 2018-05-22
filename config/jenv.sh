#!/bin/bash

if type jenv > /dev/null 2>&1; then
    if ! grep -q "jenv init" ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo "export PATH=\$PATH:${DIR}/jenv/bin" >> ${RCFILE}
        echo 'eval "$(jenv init -)"' >> ${RCFILE}
    fi
fi

