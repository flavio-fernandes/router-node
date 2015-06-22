# ROUTER-NODE

This repo provides a Vagrantfile with provisioning that one can use to quickly
get simple vm that routes from a private network using nat.

  
      |------ NAT Network -------|
                     |
                     | Dynamic ip
                     | 
            -----------------
            | This Router VM |
            -----------------
               |   |   | Static ip ${node_ex_ip}, [DHCPd], [DNSd]
               |   |   |
               |   |   |
      |------ Internal Network3 -------|
      vm.network "private_network", type: "dhcp", virtualbox__intnet: "mylocalnet3"
                   |   |
      |------ Internal Network2 -------|
      vm.network "private_network", type: "dhcp", virtualbox__intnet: "mylocalnet2"
                       |
      |------ Internal Network --------|
      Connect vms to this net, so they can talk to each
      other and share a dynamic link via nat. To do that, use
      vm.network "private_network", type: "dhcp", virtualbox__intnet: "mylocalnet"
      

##Pre-requisites:

### [Vagrant][0]

### [Vagrant Reload Provisioner][1]

As part of the provisioning, the vm is expected to be rebooted. In order to accomplish that,
we use the vagrant's reload plugin. Install this by issuing the following command:

    $ vagrant plugin install vagrant-reload

### Configuration knobs

If you need to tweak the default values, these are the files that you will need to look at:

- Vagrantfile
  - node_ex_ip: this is the static ip address assigned to the router interface in the internal network
  - node.vm.network: this is the internal only network that your clients should use in order to reach the router's interface

- puppet/hieradata/* : The json files in this directory contain the values used for dhcpd and dns services.

- Standard Centos 6 distro of dhcp/bind/iptables: with a few online searches you can figure all of them out. :)


[0]: https://www.vagrantup.com/ "Vagrant"
[1]: https://github.com/aidanns/vagrant-reload "Vagrant Reload"

