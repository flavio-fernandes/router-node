#!/usr/bin/env bash

set -e

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# https://www.bonusbits.com/wiki/HowTo:Install_Ruby_on_CentOS

yum -y groupinstall "Development Tools"
yum -y install zlib zlib-devel curl curl-devel openssl-devel httpd-devel apr-devel apr-util-devel sqlite-devel mysql-devel

wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p484.tar.gz

tar xvzf ruby-1.9.3-p484.tar.gz

cd ruby-1.9.3-p484
./configure
make
make install



