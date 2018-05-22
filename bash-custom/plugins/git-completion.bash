#!/bin/bash

if type brew > /dev/null 2>&1; then
    [ -f $(brew --prefix)/etc/bash_completion.d/git-completion.bash ] && source $(brew --prefix)/etc/bash_completion.d/git-completion.bash
fi
