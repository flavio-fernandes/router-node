# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", path: "puppet/scripts/bootstrap.sh"

  # ip configuration. Also, make sure this is in sync with puppet/hieradata/*
  node_ex_ip = "192.168.111.254"
  node_ex_ip2 = "192.168.112.254"
  node_ex_ip3 = "192.168.113.254"

  config.vm.provision "shell", path: "puppet/scripts/base1.sh"
  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path = "puppet/modules"
      puppet.manifest_file  = "base2.pp"
  end

  # During initial provisioning we expect yum update to get a new kernel. Because of that, we
  # will be required to reboot the vm. If you rather do that manually, simply comment out provision line below.
  # Otherwise, simply install the reload plugin in vagrant:  vagrant plugin install vagrant-reload
  config.vm.provision :reload

  config.vm.define "router-node", primary: true, autostart: true do |node|
    node.vm.box = "bento/centos-6.7"
    node.vm.hostname = "router-node"
    ## node.vm.network "private_network", ip: "#{node_ex_ip}", virtualbox__intnet: "intnet", auto_config: true
    node.vm.network "private_network", ip: "#{node_ex_ip}", virtualbox__intnet: "mylocalnet", auto_config: true
    node.vm.network "private_network", ip: "#{node_ex_ip2}", virtualbox__intnet: "mylocalnet2", auto_config: true
    node.vm.network "private_network", ip: "#{node_ex_ip3}", virtualbox__intnet: "mylocalnet3", auto_config: true
    # http://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
    node.vm.provider :virtualbox do |vb|
      # vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", "128"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
      # vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      # vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
      # vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
      vb.customize ["modifyvm", :id, "--macaddress2", "00005E000101"]
      vb.customize ["modifyvm", :id, "--macaddress3", "00005E000102"]
      vb.customize ["modifyvm", :id, "--macaddress4", "00005E000103"]
    end
    node.vm.provider "vmware_fusion" do |vf|
      vf.vmx["memsize"] = "128"
    end
    # node.vm.provision "puppet" do |puppet|
    #   puppet.hiera_config_path = "puppet/hiera.yaml"
    #   puppet.working_directory = "/vagrant/puppet"
    #   puppet.manifests_path = "puppet/manifests"
    #   puppet.manifest_file  = "router-node.pp"
    # end
    # node.vm.synced_folder ".", "/vagrant", disabled: true
  end

end
