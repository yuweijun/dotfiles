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

## install

    $ git clone https://github.com/yuweijun/dotfiles.git
    $ cd dotfiles
    $ ./install.sh

