Vagrant.configure('2') do |config|
  config.vm.box = 'bosh-lite-ubuntu-trusty'

  config.vm.provider :virtualbox do |v, override|
    override.vm.box_url = 'http://d3a4sadvqj176z.cloudfront.net/bosh-lite-virtualbox-ubuntu-trusty-286.box'
  end

  [:vmware_fusion, :vmware_desktop, :vmware_workstation].each do |provider|
    config.vm.provider provider do |v, override|
      override.vm.box_url = 'https://d3a4sadvqj176z.cloudfront.net/bosh-lite-vmware-ubuntu-trusty-0.box'
    end
  end
end
