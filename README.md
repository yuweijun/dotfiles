## update git on centos

### centos 6.5

    $ yum install -y http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm

### centos 7

    $ yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm

### github unable to access SSL connect error

    $ yum update -y nss curl libcurl

### install new git vertion

    $ yum install -y git

### install tools on centos

    $ yum install -y tmux mycli the_silver_searcher

## install tools on ubuntu

    $ sudo apt install -y tmux mycli silversearcher-ag

## install tools on macosx

    $ os/macosx.sh

## install fonts on linux

    please reference `powerline-fonts/README.md`

    $ cp powerline-fonts/*.ttf ~/.fonts
    $ fc-cache -vf ~/.fonts

## install with init

    $ git clone https://github.com/yuweijun/dotfiles.git
    $ cd dotfiles
    $ ./install.sh

### install.sh options

    1. -s: simple install
    2. -r: will execute git submodule update --remote --recursive --init
    3. -i: will execute git submodule update --recursive --init


