#!/usr/bin/env bash

set -e

if [ "$EUID" -ne "0" ]; then
  echo "This script must be run as root." >&2
  exit 1
fi

# http://www.server-world.info/en/note?os=CentOS_6&p=initial_conf&f=6
yum -y install centos-release-scl-rh centos-release-scl
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-SCLo-scl.repo
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo

# http://www.server-world.info/en/note?os=CentOS_6&p=ruby19
# http://www.server-world.info/en/note?os=CentOS_6&p=ruby19
yum --enablerepo=centos-sclo-rh -y install ruby193

cat <<EOT >> /etc/profile.d/ruby193.sh

#!/bin/bash

source /opt/rh/ruby193/enable
export X_SCLS="`scl enable ruby193 'echo $X_SCLS'`"
EOT
