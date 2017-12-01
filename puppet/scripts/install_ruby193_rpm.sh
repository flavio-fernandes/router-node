#!/usr/bin/env bash

set -e

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

wget https://github.com/flavio-fernandes/ruby-1.9.3-rpm/raw/rpm/ruby-1.9.3p545-1.el6.x86_64.rpm
yum localinstall -y ./ruby-1.9.3p545-1.el6.x86_64.rpm
