#!/usr/bin/env bash

if [[ $OSTYPE =~ ^darwin ]]; then
    mkdir -p "$HOME/.config/karabiner/assets/complex_modifications"

    DIR=${DIR:-$(pwd)}
    ln -sfn "${DIR}/karabiner/assets/complex_modifications/hyper.json" "${HOME}/.config/karabiner/assets/complex_modifications/hyper.json"
fi
