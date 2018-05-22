#!/bin/bash

if [ -n "$NVM_DIR" ]; then
    echo "NVM_DIR config exist"
elif ! $SIMPLE; then
    echo "" >> ${RCFILE}
    echo "export NVM_DIR=\"${DIR}/nvm\"" >> ${RCFILE}
    echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && source \"\$NVM_DIR/nvm.sh\"" >> ${RCFILE}
    echo "[ -s \"\$NVM_DIR/bash_completion\" ] && source \"\$NVM_DIR/bash_completion\"" >> ${RCFILE}
fi
