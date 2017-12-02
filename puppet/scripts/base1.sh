#!/usr/bin/env bash
set -e

# Disable root ssh access
echo "root:vagrant"|chpasswd
if [ ! -f /etc/ssh/sshd_config.orig ]; then cp /etc/ssh/sshd_config{,.orig}; fi
sed -i -r -e 's/^#*\s*(PermitRootLogin)\s.*$/\1 no/' /etc/ssh/sshd_config

# Enable ipv4 forwarding
if [ ! -f /etc/sysctl.conf.orig ]; then cp /etc/sysctl.conf{,.orig}; fi
sed -i -r -e 's/^#*\s*(net.ipv4.ip_forward)\s*=.*$/\1 = 1/' /etc/sysctl.conf

# Disable services we know we do not want
# https://www.hscripts.com/tutorials/linux-services/
for x in auditd kdump mdmonitor nfslock rpcgssd; do chkconfig ${x} off ; done

# Enable services we know we want, others will be added later
for x in iptables ; do chkconfig ${x} on ; done
