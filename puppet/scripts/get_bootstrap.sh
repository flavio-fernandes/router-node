#!/usr/bin/env bash
set -e
wget -O ./bootstrap.sh https://raw.githubusercontent.com/flavio-fernandes/puppet-bootstrap/master/centos_6_x.sh
chmod 755 ./bootstrap.sh

cat <<EOT >> ./bootstrap.sh

# This file was pulled from git@github.com:flavio-fernandes/puppet-bootstrap.git
EOT
