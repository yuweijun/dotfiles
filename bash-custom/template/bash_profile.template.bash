#!/usr/bin/env bash

export BASH_IT="{{BASH_IT}}"
export SCM_CHECK=true
export BASH_IT_THEME='powerline'

POWERLINE_PROMPT="clock user_info hostname python_venv ruby cwd scm"

# FIX sed on Mac OSX: RE error: illegal byte sequence
alias sed="LC_CTYPE=C sed"

source "$BASH_IT"/bash_it.sh