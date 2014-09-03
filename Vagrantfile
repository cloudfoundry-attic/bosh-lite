VM_MEMORY = ENV.fetch('VM_MEMORY', 6*1024).to_i
VM_CORES = ENV.fetch('VM_CORES', 4).to_i

# better error messages from Hash.fetch
env = ENV.to_hash

def tags_from_environment(env)
  values = [env.fetch('BOSH_LITE_NAME', 'Vagrant')]
  values.concat env.fetch('BOSH_LITE_TAG_VALUES', '').chomp.split(', ')

  keys = ['Name']
  keys.concat env.fetch('BOSH_LITE_TAG_KEYS', '').chomp.split(', ')

  raise 'Please provide the same number of keys and values!' if keys.length != values.length

  Hash[keys.zip(values)]
end

Vagrant.configure('2') do |config|
  config.vm.define :local do |local|
    local.vm.network :private_network, ip: '192.168.50.4'
    local.vm.box = 'bosh-lite-ubuntu-trusty'

    local.vm.hostname='bosh-lite'

    local.vm.provider :virtualbox do |v, override|
      #CDN in front of bosh-lite-build-artifacts.s3.amazonaws.com
      override.vm.box_url = 'http://d3a4sadvqj176z.cloudfront.net/bosh-lite-virtualbox-ubuntu-trusty-286.box'
      v.customize ['modifyvm', :id, '--memory', VM_MEMORY]
      v.customize ['modifyvm', :id, '--cpus', VM_CORES]
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    end

    [:vmware_fusion, :vmware_desktop, :vmware_workstation].each do |provider|
      local.vm.provider provider do |v, override|
        v.vmx["numvcpus"] = VM_CORES
        v.vmx["memsize"] = VM_MEMORY
      end
    end
  end

  config.vm.define :remote do |remote|
    remote.vm.box = 'bosh-lite-ubuntu-trusty'
    remote.vm.synced_folder '.', '/vagrant', disabled: true
    remote.vm.box_url = 'https://github.com/mitchellh/vagrant-aws/blob/master/dummy.box?raw=true'

    remote.vm.provider :aws do |v, override|
      v.access_key_id =       env.fetch('BOSH_AWS_ACCESS_KEY_ID')
      v.secret_access_key =   env.fetch('BOSH_AWS_SECRET_ACCESS_KEY')

      v.keypair_name =        env.fetch('BOSH_LITE_KEYPAIR', 'bosh')

      v.ami = `curl -s https://bosh-lite-build-artifacts.s3.amazonaws.com/ami/bosh-lite-ami.list |tail -1`.chop
      v.block_device_mapping = [
          {
            :DeviceName => '/dev/sda1',
            'Ebs.VolumeSize' => env.fetch('BOSH_LITE_DISK_SIZE', '50').to_i
          }
      ]
      v.instance_type =       env.fetch('BOSH_LITE_INSTANCE_TYPE', 'm3.xlarge')
      
      v.tags =                tags_from_environment(env)
      # use SG-names when deploying to EC2 classic but SG-IDs when deploying to a VPC
      v.security_groups = [   env.fetch('BOSH_LITE_SECURITY_GROUP', 'inception') ]

      v.subnet_id =           env.fetch('BOSH_LITE_SUBNET_ID') if env.include?('BOSH_LITE_SUBNET_ID')

      override.ssh.username = 'ubuntu'
      override.ssh.private_key_path = env.fetch('BOSH_LITE_PRIVATE_KEY', '~/.ssh/id_rsa_bosh')
    end

    PORT_FORWARDING = <<-IP_SCRIPT
public_ip=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
echo "The public IP for this instance is $public_ip"
echo "You can bosh target $public_ip, or run vagrant ssh and then bosh target 127.0.0.1"

local_ip=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
echo "Setting up port forwarding for the CF Cloud Controller..."
sudo iptables -t nat -A PREROUTING -p tcp -d $local_ip --dport 80 -j DNAT --to 10.244.0.34:80
sudo iptables -t nat -A PREROUTING -p tcp -d $local_ip --dport 443 -j DNAT --to 10.244.0.34:443
sudo iptables -t nat -A PREROUTING -p tcp -d $local_ip --dport 4443 -j DNAT --to 10.244.0.34:4443
    IP_SCRIPT
    remote.vm.provision :shell, :inline => PORT_FORWARDING
  end
end
