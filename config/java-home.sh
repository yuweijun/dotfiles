#!/bin/bash

if [ -e /usr/libexec/java_home ]; then
    if ! grep -q "export JAVA_HOME" ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)' >> ${RCFILE}
    fi
fi

