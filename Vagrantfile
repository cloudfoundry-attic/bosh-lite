Vagrant.configure('2') do |config|
  config.vm.provider :virtualbox do |v, override|
    override.vm.box = 'bosh-lite-ubuntu-trusty-virtualbox-293'
    override.vm.box_url = 'http://d3a4sadvqj176z.cloudfront.net/bosh-lite-virtualbox-ubuntu-trusty-293.box'

    # To use a different IP address for the bosh-lite director, uncomment this line:
    override.vm.network :private_network, ip: '192.168.59.4', auto_config: false, id: :local
  end

  [:vmware_fusion, :vmware_desktop, :vmware_workstation].each do |provider|
    config.vm.provider provider do |v, override|
      override.vm.box = 'bosh-lite-ubuntu-trusty-vmware-15'
      override.vm.box_url = 'https://d3a4sadvqj176z.cloudfront.net/bosh-lite-vmware-ubuntu-trusty-15.box'

      # To use a different IP address for the bosh-lite director, uncomment this line:
      # override.vm.network :private_network, ip: '192.168.54.4', id: :local
    end
  end

  config.vm.provider :aws do |v, override|
    override.vm.box = 'bosh-lite-ubuntu-trusty-aws-174'
    override.vm.box_url = 'https://d3a4sadvqj176z.cloudfront.net/bosh-lite-aws-ubuntu-trusty-174.box'

    # To turn off public IP echoing, uncomment this line:
    # override.vm.provision :shell, id: "public_ip", run: "always", inline: "/bin/true"

    # To turn off CF port forwarding, uncomment this line:
    # override.vm.provision :shell, id: "port_forwarding", run: "always", inline: "/bin/true"
  end
end
