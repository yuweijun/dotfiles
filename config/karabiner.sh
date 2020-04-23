#!/usr/bin/env bash

mkdir -p "$HOME/.config/karabiner/assets/complex_modifications"

DIR=${DIR:-$(pwd)}
ln -sfn "${DIR}/karabiner/assets/complex_modifications/hyper.json" "${HOME}/.config/karabiner/assets/complex_modifications/hyper.json"
