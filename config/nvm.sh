#!/bin/bash

if ! $SIMPLE; then
    echo "" >> ${RCFILE}
    echo "export NVM_DIR=\"${DIR}/nvm\"" >> ${RCFILE}
fi
