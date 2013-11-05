Vagrant.configure('2') do |config|
  VM_MEMORY = 6*1024
  VM_CORES = 4
  DIRECTOR_IP = '192.168.50.4'

  config.vm.hostname='bosh-lite'
  config.omnibus.chef_version = :latest
  config.vm.box = 'precise64'
  config.vm.box_url = 'http://files.vagrantup.com/precise64.box'

  config.vm.provider :virtualbox do |v, override|
    v.customize ["modifyvm", :id, "--memory", VM_MEMORY]
    v.customize ["modifyvm", :id, "--cpus", VM_CORES]
  end

  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box_url = 'http://files.vagrantup.com/precise64_vmware.box'
    v.vmx["numvcpus"] = VM_CORES
    v.vmx["memsize"] = VM_MEMORY
  end

  config.vm.network :private_network, ip: DIRECTOR_IP

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :director_ip => DIRECTOR_IP
    }

    chef.cookbooks_path = ['cookbooks', 'site-cookbooks']

    chef.add_recipe 'bosh-lite::apt-update'
    chef.add_recipe 'bosh-lite::warden'
    chef.add_recipe 'bosh-lite::bosh'
    chef.add_recipe 'bosh-lite::update-kernel'
    chef.add_recipe 'bosh-lite::reboot'
  end
end

