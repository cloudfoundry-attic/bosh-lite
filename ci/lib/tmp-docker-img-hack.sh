set -e -x

apt-get -y update

# install ruby
apt-get install -y ruby ruby-dev

# bundler
apt-get install -y postgresql-server-dev-9.4
apt-get install -y libsqlite3-dev
apt-get install -y libmysqlclient-dev
gem install bundler

apt-get install -y wget

# s3cmd for pushing assets
apt-get install -y python-dateutil
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8BAF9A6F
apt-get install -y python-setuptools
wget --progress bar:force https://github.com/s3tools/s3cmd/archive/v1.5.0-rc1.tar.gz -O v1.5.0-rc1.tar.gz
tar xvf v1.5.0-rc1.tar.gz
( cd s3cmd-1.5.0-rc1 && python setup.py install )
ln -s /usr/local/bin/s3cmd /usr/bin/s3cmd

# jq
apt-get install -y jq

# awscli
apt-get -y install awscli

# for syncing folders via vagrant
apt-get -y install rsync

# used by nokogiri
apt-get install -y libxslt-dev libxml2-dev

# vagrant
wget --progress bar:force https://releases.hashicorp.com/vagrant/1.6.5/vagrant_1.6.5_x86_64.deb -O /tmp/vagrant.deb
dpkg -i /tmp/vagrant.deb

# chefdk for vagrant up
wget --progress bar:force https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb -O chefdk_0.4.0-1_amd64.deb
dpkg -i chefdk_0.4.0-1_amd64.deb

# vagrant plugins for building stemcells
(
	set -e -x
	export HOME=/root
	vagrant plugin install vagrant-aws --plugin-version 0.5.0
	vagrant plugin install vagrant-berkshelf
	vagrant plugin install vagrant-omnibus
)

# for making calls to VagrantCloud
apt-get -y install curl
