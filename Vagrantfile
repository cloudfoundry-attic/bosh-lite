Vagrant.configure('2') do |config|
  config.vm.hostname='bosh-lite'

  config.vm.box = 'precise64'

  #config.vm.provider :vmware_fusion do |v, override|
  #  override.vm.box = 'precise64 (vmware_fusion)'
  #end

  config.vm.network :private_network, ip: '192.168.50.4'

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['cookbooks', 'site-cookbooks']

    chef.add_recipe 'build-essential::default'
    chef.add_recipe 'bosh-lite::docker'
    chef.add_recipe 'bosh-lite::bosh'
    chef.add_recipe 'bosh-lite::apt-update'
  end
end

