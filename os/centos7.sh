#!/bin/bash

cd $(dirname "$0")

yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
./centos.sh
