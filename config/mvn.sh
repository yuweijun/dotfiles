#!/bin/bash

if [ -e /usr/libexec/java_home ]; then
    JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
else
    JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))
fi

echo -e "export JAVA_HOME=${JAVA_HOME}" > ${HOME}/.mavenrc

