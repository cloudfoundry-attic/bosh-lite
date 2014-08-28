#!/bin/bash

set -x

# Make sure Udev doesn't block our network (http://6.ptmc.org/?p=164)
echo "Cleaning up udev rules"
rm -rf /etc/udev/rules.d/70-persistent-net.rules
rm -rf /lib/udev/rules.d/75-persistent-net-generator.rules
rm -rf /dev/.udev/

echo "Cleaning up BOSH provisioner left-overs"
rm -rf /opt/bosh-provisioner/{repos,blobstore,tmp,assets}
rm -rf /var/vcap/data/compile
rm -rf /var/vcap/data/tmp/*blobstore*

echo "Cleaning up /tmp"
rm -rf /tmp/*

echo "Cleaning up /home/vagrant"
rm -rf /home/vagrant/*

if [ -d "/var/lib/dhcp" ]; then
	echo "Removing DHCP leases"
	rm /var/lib/dhcp/*
fi

apt-get -y autoremove --purge
apt-get -y clean
