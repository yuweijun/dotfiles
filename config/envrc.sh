#!/bin/bash

RCFILE=${RCFILE:-.bashrc}
echo "" >> ${RCFILE}
echo '[ -f $HOME/.envrc ] && source $HOME/.envrc' >> ${RCFILE}
