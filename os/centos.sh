#!/bin/bash

yum update  -y nss  curl  libcurl
yum install -y git
yum install -y tmux mycli the_silver_searcher mosh multitail

pip install virtualenv
