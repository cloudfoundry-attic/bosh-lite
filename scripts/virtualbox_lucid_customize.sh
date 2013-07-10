set -x

# Kernel backporting for Warden
apt-get install -y linux-image-generic-lts-backport-natty

# Redis 2.x installed for lucid
wget --no-verbose -c http://mirror.pnl.gov/ubuntu//pool/universe/r/redis/redis-server_2.2.12-1build1_amd64.deb -O /tmp/redis-2.2.12.deb
dpkg -i /tmp/redis-2.2.12.deb

if which chef-solo ;then
  gem list chef |grep -q 10.26.0 || gem uninstall chef
fi
gem install chef --no-ri --no-rdoc -v 10.26.0
