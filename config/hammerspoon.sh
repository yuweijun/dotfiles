#!/usr/bin/env bash

if [[ $OSTYPE =~ ^darwin ]]; then
    DIR=${DIR:-$(pwd)}
    ln -sfn "${DIR}/hammerspoon" "${HOME}/.hammerspoon"
fi
