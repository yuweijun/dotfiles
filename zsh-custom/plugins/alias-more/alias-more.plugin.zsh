alias lt='ls -lat'
alias ll='ls -alF'
alias ld='ls -ad'
alias la='ls -A'
alias l='ls -aCF'

if type nvim > /dev/null 2>&1; then
    alias vim="nvim"
fi

alias vi="vim"
alias vzrc='vi ~/.zshrc'

if type gls > /dev/null 2>&1; then
    # gnu-ls command for Mac OS
    alias ls="gls --color=auto"
    # Mac OS ls original command
    alias lo="/bin/ls"
elif type exa > /dev/null 2>&1; then
    alias ls="exa"
    alias llt="exa -lTL 2"
fi

if type bat > /dev/null 2>&1; then
    alias cat="bat"
fi

