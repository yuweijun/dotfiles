# Mac OS ls original command
alias lo="/bin/ls"
alias lt='ls -lat'
alias ll='ls -la'
alias ld='ls -ad'
alias la='ls -a'
alias l='ls -a'

if type nvim &> /dev/null; then
    alias vim="nvim"
fi

alias vi="vim"
alias vzrc='vi ~/.zshrc'

if type git &> /dev/null; then
    alias master="git checkout master"
fi

if type gls &> /dev/null; then
    # gnu-ls command for Mac OS
    alias ls="gls --color=auto"
elif type colorls &> /dev/null; then
    # sudo gem install colorls
    alias ls="colorls"
elif type exa &> /dev/null; then
    alias ls="exa"
    alias lt="exa -la -t modified"
fi

if type bat &> /dev/null; then
    alias cat="bat -p"
fi

if type systemctl &> /dev/null; then
    alias sc-running='systemctl list-units --type=service --state=running'
fi

