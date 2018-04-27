## update git on centos

### contos 6.5

    $ yum install http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm

### contos 7

    $ yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm

### install new git vertion

    $ yum install git

### Github unable to access SSL connect error

    $ yum update -y nss curl libcurl

## run init script

    $ git clone https://github.com/yuweijun/dotfiles.git
    $ cd dotfiles
    $ ./init.sh
