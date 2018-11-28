#!/bin/bash

JAVA_HOME=""

if [ -e /usr/libexec/java_home ]; then
    JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
else
    if [ type javac 2> /dev/null ]; then
        JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
    fi
fi

echo -e "export JAVA_HOME=${JAVA_HOME}" > ${HOME}/.mavenrc

