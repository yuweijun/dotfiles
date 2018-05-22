#!/bin/bash

if [ -n "$NVM_DIR" ]; then
    echo "NVM_DIR config exist"
fi

if ! $SIMPLE; then
    echo "" >> ${RCFILE}
    echo "export NVM_DIR=\"${DIR}/nvm\"" >> ${RCFILE}
fi
