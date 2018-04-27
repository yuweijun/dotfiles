## update git on centos

### centos 6.5

    $ yum install http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm

### centos 7

    $ yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm

### install new git vertion

    $ yum install git

### github unable to access SSL connect error

    $ yum update -y nss curl libcurl

## install

    $ git clone https://github.com/yuweijun/dotfiles.git
    $ cd dotfiles
    $ ./install.sh

### greys.sh please set $JAVA_HOME to JDK6+

    $ JAVA_HOME=/usr/lib/jvm/java-8-oracle/ greys-anatomy/bin/greys.sh pid-of-java

