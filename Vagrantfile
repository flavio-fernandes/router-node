# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # ssh tinkering...
  # ref: http://stackoverflow.com/questions/14715678/vagrant-insecure-by-default
  # ref: https://www.vagrantup.com/docs/vagrantfile/ssh_settings.html
  config.ssh.insert_key = false
  ##config.ssh.paranoid = false
  ##config.ssh.keys_only = false
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'" # avoids 'stdin: is not a tty' error.
    config.vm.provision "shell", inline: <<-SCRIPT
    if [ ! -f /home/vagrant/.ssh/id_rsa.pub ] ; then
        mkdir -pv /home/vagrant/.ssh
        ssh-keygen -t rsa -f /home/vagrant/.ssh/id_rsa -N ''
    fi
    cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    printf "%s\n" "#{File.read("#{ENV['HOME']}/.ssh/id_rsa.pub")}" >> /home/vagrant/.ssh/authorized_keys
    chown -R vagrant:vagrant /home/vagrant/.ssh
    chmod 600 /home/vagrant/.ssh/id_rsa
  SCRIPT

  config.vm.provision "shell", path: "puppet/scripts/bootstrap.sh"

  # ip configuration. Also, make sure this is in sync with puppet/hieradata/*
  node_ex_ip = "192.168.111.254"
  node_bridge_ip = "192.168.50.254"
  node_provider_gw = "10.10.0.1"
  node_provider_gw_mask = "255.255.0.0"

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
    # node.vm.network "public_network", ip: "#{node_bridge_ip}", bridge: "tap1"
    # node.vm.network "private_network", ip: "#{node_bridge_ip}", virtualbox__intnet: "net50", auto_config: true
    node.vm.network "private_network", ip: "#{node_bridge_ip}", auto_config: true
    node.vm.network "private_network", ip: "#{node_ex_ip}", virtualbox__intnet: "mylocalnet", auto_config: true
    node.vm.network "private_network", ip: "#{node_provider_gw}", netmask: "#{node_provider_gw_mask}", virtualbox__intnet: "providernet", auto_config: true
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
      vb.customize ["modifyvm", :id, "--nictype4", "Am79C973"]
      vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
      vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
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
