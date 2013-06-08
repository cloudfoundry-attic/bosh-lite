

apt_repository 'r-lts-backport' do
  uri 'http://ppa.launchpad.net/ubuntu-x-swat/r-lts-backport/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key 'AF1CDFA9'
end

apt_repository 'lxc-docker' do
  uri 'http://ppa.launchpad.net/dotcloud/lxc-docker/ubuntu'
  distribution node['lsb']['codename']
  components ['main']
  keyserver 'keyserver.ubuntu.com'
  key '63561DC6'
end

%w(python-software-properties lxc-docker linux-image-3.8.0-19-generic linux-headers-3.8.0-19-generic dkms).each do |package_name|
  package package_name
end
