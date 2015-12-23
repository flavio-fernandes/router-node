# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", path: "puppet/scripts/bootstrap.sh"

  # ip configuration. Also, make sure this is in sync with puppet/hieradata/*
  node_ex_ip = "192.168.111.254"
  node_bridge_ip = "192.168.50.254"

  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      ## no module path added here, as this manifest populates the puppet modules directory
      ## puppet.module_path = "puppet/modules"
      puppet.manifest_file  = "base1.pp"
  end
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
    node.vm.box = "centos6.6-i386"
    node.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.6-i386_chef-provisionerless.box"
    node.vm.provider "vmware_fusion" do |v, override|
      override.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/vmware/opscode_centos-6.6-i386_chef-provisionerless.box"
    end
    node.vm.hostname = "router-node"
    node.vm.network "public_network", ip: "#{node_bridge_ip}", bridge: "tap1"
    node.vm.network "private_network", ip: "#{node_ex_ip}", virtualbox__intnet: "mylocalnet", auto_config: true
    # http://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
    node.vm.provider :virtualbox do |vb|
      # vb.gui = true
      vb.customize ["modifyvm", :id, "--memory", "128"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
      vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
      vb.customize ["modifyvm", :id, "--audio", "none"]
      vb.customize ["modifyvm", :id, "--nictype1", "Am79C973"]
      vb.customize ["modifyvm", :id, "--nictype2", "Am79C973"]
      vb.customize ["modifyvm", :id, "--nictype3", "Am79C973"]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
      vb.customize ["modifyvm", :id, "--macaddress2", "00005E000101"]
      vb.customize ["modifyvm", :id, "--macaddress3", "00005E000102"]
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
