#!/usr/bin/env bash

export BASH_IT="$HOME/.bash-it"
export SCM_CHECK=true
export BASH_IT_THEME='powerline'

POWERLINE_PROMPT="clock user_info hostname cwd scm"

source "$BASH_IT"/bash_it.sh
[ -f $HOME/.envrc ] && source $HOME/.envrc
