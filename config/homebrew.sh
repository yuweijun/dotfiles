#!/bin/bash

if [[ "$SHELL" != */bin/bash* ]]; then
    exit 0
fi

if type brew 2> /dev/null; then
    if ! grep -q git-completion.bash ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo "HOMEBREW_NO_AUTO_UPDATE=1 brew install bash-completion"
        echo '[ -f $(brew --prefix)/etc/bash_completion.d/git-completion.bash ] && source $(brew --prefix)/etc/bash_completion.d/git-completion.bash' >> ${RCFILE}
    fi
fi
