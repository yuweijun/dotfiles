# Mac OS ls original command
alias lo="/bin/ls"
alias lt='ls -lat'
alias ll='ls -la'
alias ld='ls -ad'
alias la='ls -a'
alias l='ls -a'

if type nvim > /dev/null 2>&1; then
    alias vim="nvim"
fi

alias vi="vim"
alias vzrc='vi ~/.zshrc'

if type gls > /dev/null 2>&1; then
    # gnu-ls command for Mac OS
    alias ls="gls --color=auto"
elif type colorls > /dev/null 2>&1; then
    # sudo gem install colorls
    alias ls="colorls"
elif type exa > /dev/null 2>&1; then
    alias ls="exa"
    alias lt="exa -la -t modified"
fi

if type bat > /dev/null 2>&1; then
    alias cat="bat -p"
fi

if type systemctl > /dev/null 2>&1; then
    alias srvs='systemctl list-units --type=service --state=running'
fi

