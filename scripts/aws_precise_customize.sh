set -x
apt-get update


apt-get -y install ruby1.9.1-full ruby1.9.1-dev libopenssl-ruby1.9.1 rdoc1.9.1 ri1.9.1 irb1.9.1 build-essential wget ssl-cert curl
apt-get -y install rubygems1.9.1
grep -q gems/1.9.1 /etc/profile || echo 'export PATH=$PATH:/var/lib/gems/1.9.1/bin' >> /etc/profile

# Install Chef
which chef-solo || gem install chef --no-ri --no-rdoc -v 10.26.0

# Add user vagrant
grep -q vagrant /etc/passwd || useradd vagrant

ifconfig lo:1 192.168.50.4 netmask 255.255.255.0
